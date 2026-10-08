# Root's Anomalies

![version](https://img.shields.io/badge/version-5.0.0.9-blue) ![build](https://img.shields.io/badge/build-passing-green)

A modular framework of anomalies, creatures and SCP-style entities for Arma 3, usable from
**both the 3DEN Editor and Zeus (Game Master)**. Originally based on the 3DEN showcase by
Aliascartoons; fully refactored, modernised and expanded by Root.

## Highlights

- **Dual interface** — every entity ships as a **3DEN Editor module** *and* a **Zeus (ZEN) module**,
  driven by the same server backend.
- **Per-PBO modular** — each anomaly is its own PBO. Don't want the Swarmer? Delete
  `root_anomalies_swarmer.pbo` and everything else keeps working. Only `root_anomalies_main` is
  always required.
- **Works with or without ACE** — damage routes through ACE Medical when present and falls back to
  vanilla otherwise.
- **Fully parameterised** — territory, damage, health, devices, behaviour toggles, etc. exposed per
  module.
- **CBA settings** — debug logging (on by default: every module use, spawn, attack, damage, sedation and capture is written to the RPT with the machine, mission time and player; optional chat relay for Zeus), global affect whitelist / immune blacklist, default
  device classnames and a global seizure-safe override (Game / Addon Options → *Root's Anomalies*).
- **Accessibility** — per-module and global "disable sensitive lights" options for photosensitive
  players.

## Requirements

- [CBA_A3](https://github.com/CBATeam/CBA_A3)
- [Zeus Enhanced (ZEN)](https://github.com/zen-mod/ZEN) — required for the Zeus modules
- ACE3 — **optional** (enhances damage/medical integration when loaded)

## Entities

| PBO | Entity | Summary |
|-----|--------|---------|
| `burper`   | Burper   | Invisible destroyer; detector/protection/killswitch devices. |
| `farmer`   | Farmer   | Burrowing shockwave creature that teleports to its prey. |
| `flamer`   | Flamer   | Burning, leaping creature that ignites everything nearby. |
| `screamer` | Screamer | Static/living entity emitting a directional sonic blast. |
| `smuggler` | Smuggler | Invisible teleporter that scrambles units/vehicles and conjures objects. |
| `steamer`  | Steamer  | Invisible entity erupting geyser bursts beneath targets; its death tears the ground open and throws everything nearby. |
| `strigoi`  | Strigoi  | Spectral stamina-drainer that hops between trees (night-only option). |
| `swarmer`  | Swarmer  | Insect hive whose fly swarm devours victims; killed with its configured pesticide. |
| `twins`    | Twins    | Electric anomaly with a vulnerable "heart"; freezes when observed; EMP on death. |
| `worm`     | Worm     | Burrowing creature that erupts and flings/strikes targets; killed with a diffuser, baited by a diversion device for a set number of attacks. |
| `scp173`   | SCP-173  | Cannot move while observed; blinks to the nearest victim and snaps their neck. |
| `scp096`   | SCP-096  | Docile until its face is seen, then sprints to and kills the viewer. |
| `wraith`   | Wraith   | Ground-walking stalker stitched from Strigoi, Flamer and Farmer flesh; invisible to the naked eye, only seen through night vision and/or thermal optics. |

> SCP-173 and SCP-096 use the default VR soldier as a placeholder model.

## Sedation and capture

Every anomaly can be sedated and captured, with or without ACE.

1. Throw a **sedative smoke** near it: the default sedative, or the classes set in the module's
   *Sedation Classes* (magazine or ammo names, e.g. `SmokeShellGreen`). A kill device (Swarmer
   pesticide, Worm diffuser) never counts as a sedative.
2. While sedated the anomaly **comes out of hiding, is frozen in place, cannot hurt anyone** and the
   capture action appears on it: ACE interaction *Capture Anomaly* (progress bar), or a vanilla hold
   action within 6 m without ACE.
3. It stays down for *Sedation Time* seconds after the last smoke clears, then wakes up and stays
   docile for *Post-Sedation Cooldown* seconds before attacking again.
4. Completing the capture removes the anomaly and raises the `root_anomalies_captured` event.

The Steamer is sedated by smoke anywhere in its territory and materialises where the smoke landed.
The Farmer catches smoke within 25 m. All of these options exist in both the 3DEN modules and the Zeus
dialogs.

## Multiplayer

Works in single player, hosted multiplayer and on dedicated servers, with or without headless
clients. Every anomaly runs on the server; effects and sounds play on each client (JIP safe). Thrown
kill devices and sedatives are detected whoever throws them (players, AI or headless clients, ACE
advanced throwing or vanilla).

## Usage

- **3DEN Editor**: Systems (F5) → *Root's Anomalies* → place a module, double-click to set its
  attributes. Anomalies activate on mission start.
- **Zeus**: open the Game Master interface → *Root's Anomalies* category → place a module to open its
  configuration dialog.

## Building

Built with [HEMTT](https://hemtt.dev):

```powershell
hemtt check -p -Lc14 -e   # lint (must be clean)
hemtt build               # dev/test build  -> .hemttout/build
hemtt release             # signed release  -> .hemttout/release
```

## Repository layout

```
addons/
  main/                    core: CBA settings, shared functions, sounds, macros
  <entity>/                one PBO per anomaly/creature (config + functions/)
include/x/cba/...          CBA macro header for compilation
.hemtt/project.toml        HEMTT project + lint configuration
```

## License

[Arma Public License - Share Alike](LICENSE).
