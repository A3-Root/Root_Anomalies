#!/usr/bin/env python3
import subprocess
import os
from pathlib import Path
from packaging.version import Version # type: ignore
from collections import defaultdict

def get_changelog_notes(version=None):
    """Extract changelog section from releases/CHANGELOG.md for a specific version.
    Anomalies format: '## Version: X.Y.Z - Description' or '## Version: X.Y.Z.W - Description'
    Falls back to matching on major.minor.patch if 4-part version has no exact match.
    """
    changelog_path = Path("releases/CHANGELOG.md")
    if not changelog_path.exists():
        return "Automated release"

    try:
        with open(changelog_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()

        def version_matches(line, target_version):
            """Check if a '## Version:' line matches the target version."""
            if not line.startswith("## Version:"):
                return False
            # Extract the version string after '## Version: '
            rest = line[len("## Version:"):].strip()
            # Version is the first token before ' - ' or end of string
            v_str = rest.split(" - ")[0].split()[0] if rest else ""
            if v_str == target_version:
                return True
            # Try matching on first 3 parts (major.minor.patch) for 4-part versions
            target_parts = target_version.split(".")
            v_parts = v_str.split(".")
            if len(target_parts) == 4 and len(v_parts) == 3:
                return ".".join(target_parts[:3]) == v_str
            return False

        section = []
        in_section = False
        found_version = False

        for line in lines:
            if line.startswith("## "):
                if in_section:
                    break
                if version is None:
                    in_section = True
                    section.append(line.strip())
                elif version_matches(line, version):
                    in_section = True
                    found_version = True
                    section.append(line.strip())
            elif in_section:
                section.append(line.rstrip())

        if version is not None and not found_version:
            return None

        return "\n".join(section) if section else "Automated release"
    except Exception as e:
        print(f"⚠️  Could not read changelog: {e}")
        return "Automated release"

def get_version_from_filename(filename):
    """Extract version from filename like root_anomalies-5.0.0.2.zip"""
    try:
        return filename.split("root_anomalies-")[1].split(".zip")[0]
    except:
        return None

def main():
    releases_dir = Path("releases")

    if not releases_dir.exists():
        print("📁 Releases directory does not exist, nothing to process")
        return

    # Exclude the rolling 'latest' alias
    versioned_zips = [
        z for z in releases_dir.glob("root_anomalies-*.zip")
        if z.name != "root_anomalies-latest.zip"
    ]

    if not versioned_zips:
        print("📭 No versioned release files found")
        return

    print(f"📦 Found {len(versioned_zips)} versioned release files")

    for zip_file in versioned_zips:
        version = get_version_from_filename(zip_file.name)
        if not version:
            print(f"⚠️  Could not extract version from {zip_file.name}, skipping")
            continue

        print(f"🚀 Processing version: {version}")

        notes = get_changelog_notes(version)

        if notes is None:
            print(f"⚠️  No changelog entry found for version {version}, skipping release note update")
            continue

        title = f"Version {version}"

        result = subprocess.run(
            ["gh", "release", "view", version],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        release_exists = result.returncode == 0

        if release_exists:
            print(f"🔄 Release {version} exists, updating...")

            assets_proc = subprocess.run(
                ["gh", "release", "view", version, "--json", "assets", "--jq", ".assets[].name"],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE
            )

            if assets_proc.returncode == 0:
                assets = assets_proc.stdout.decode().strip().splitlines()
                for asset in assets:
                    if asset:
                        print(f"🗑️  Deleting old asset: {asset}")
                        subprocess.run(
                            ["gh", "release", "delete-asset", version, asset, "--yes"],
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE
                        )

            subprocess.run([
                "gh", "release", "upload", version, str(zip_file), "--clobber"
            ], check=True)

            subprocess.run([
                "gh", "release", "edit", version,
                "--title", title,
                "--notes", notes
            ], check=True)

            print(f"✅ Updated release: {version}")
        else:
            print(f"🆕 Creating new release: {version}")
            subprocess.run([
                "gh", "release", "create", version, str(zip_file),
                "--title", title,
                "--notes", notes
            ], check=True)
            print(f"✅ Created new release: {version}")

    # Mark newest as latest
    if versioned_zips:
        newest_version = None
        newest_version_obj = None

        for zip_file in versioned_zips:
            version = get_version_from_filename(zip_file.name)
            if version:
                try:
                    version_obj = Version(version)
                    if newest_version_obj is None or version_obj > newest_version_obj:
                        newest_version = version
                        newest_version_obj = version_obj
                except:
                    continue

        if newest_version:
            print(f"🏷️  Marking {newest_version} as latest...")
            result = subprocess.run(
                ["gh", "release", "view", newest_version],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE
            )
            if result.returncode == 0:
                subprocess.run([
                    "gh", "release", "edit", newest_version,
                    "--latest"
                ], check=True)
                print(f"✅ Marked {newest_version} as latest release")
            else:
                print(f"⚠️  Release {newest_version} does not exist, cannot mark as latest")
        else:
            print("⚠️  Could not determine newest version")

    print("🧹 Applying retention policy...")
    apply_retention_policy(versioned_zips)

def apply_retention_policy(versioned_zips):
    """Keep 1 major, 2 minor, 3 patch versions and delete the rest locally"""
    version_map = defaultdict(list)

    for zip_file in versioned_zips:
        version = get_version_from_filename(zip_file.name)
        if version:
            try:
                Version(version)
                version_map[version].append(zip_file)
            except:
                continue

    if not version_map:
        print("📭 No valid versioned files found for retention policy")
        return

    def get_version_keys(version_str):
        v = Version(version_str)
        return {
            "major": f"{v.major}",
            "minor": f"{v.major}.{v.minor}",
            "patch": f"{v.major}.{v.minor}.{v.micro}"
        }

    major_map = defaultdict(list)
    minor_map = defaultdict(list)
    patch_map = defaultdict(list)

    for v_str in version_map:
        keys = get_version_keys(v_str)
        major_map[keys["major"]].append(v_str)
        minor_map[keys["minor"]].append(v_str)
        patch_map[keys["patch"]].append(v_str)

    kept_versions = set()

    latest_major = sorted(major_map.keys(), key=Version, reverse=True)[:1]

    for major in latest_major:
        minors = sorted(set([f"{major}.{Version(v).minor}" for v in major_map[major]]),
                       key=Version, reverse=True)[:2]
        for minor in minors:
            patches = sorted(set([f"{minor}.{Version(v).micro}" for v in minor_map[minor]]),
                            key=Version, reverse=True)[:3]
            for patch in patches:
                builds = sorted([v for v in patch_map[patch]], key=Version, reverse=True)
                if builds:
                    kept_versions.add(builds[0])

    print(f"🔒 Keeping versions: {sorted(kept_versions)}")

    deleted_any = False
    for zip_file in versioned_zips:
        version = get_version_from_filename(zip_file.name)
        if version and version not in kept_versions:
            print(f"🗑️  Deleting old local archive: {zip_file.name}")
            zip_file.unlink()
            deleted_any = True

    if deleted_any:
        subprocess.run(["git", "config", "user.name", "github-actions"], check=True)
        subprocess.run(["git", "config", "user.email", "github-actions@github.com"], check=True)
        subprocess.run(["git", "add", "releases/"], check=True)
        subprocess.run(["git", "commit", "-m", "Cleanup: remove old mod releases"], check=True)
        subprocess.run(["git", "push"], check=True)
        print("✅ Cleanup committed to repository")
    else:
        print("✅ No old files to clean up")

if __name__ == "__main__":
    main()
