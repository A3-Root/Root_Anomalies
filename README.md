# Root's Anomalies

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
- **CBA settings** — verbose debug logging, global affect whitelist / immune blacklist, default
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
| `steamer`  | Steamer  | Invisible entity erupting geyser bursts beneath targets. |
| `strigoi`  | Strigoi  | Spectral stamina-drainer that hops between trees (night-only option). |
| `swarmer`  | Swarmer  | Insect hive whose fly swarm devours victims; killed with pesticide. |
| `twins`    | Twins    | Electric anomaly with a vulnerable "heart"; freezes when observed; EMP on death. |
| `worm`     | Worm     | Burrowing creature that erupts and flings/strikes targets; killed with a diffuser. |
| `scp173`   | SCP-173  | Cannot move while observed; blinks to the nearest victim and snaps their neck. |
| `scp096`   | SCP-096  | Docile until its face is seen, then sprints to and kills the viewer. |
| `wraith`   | Wraith   | Floating demon that teleport-stalks the living, burning them and radiating dread. |

> New creatures (SCP-173, SCP-096, Wraith) use the default VR soldier as a placeholder model.

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

Each entity PBO exposes `Root_fnc_<Name>Main` (server backend) plus a `…Zeus` and `…3DEN` front-end.
Shared helpers live in `main`: `Root_fnc_applyDamage`, `Root_fnc_isAffectable`,
`Root_fnc_parseClassList`, `Root_fnc_initSettings`.

## License

See [LICENSE](LICENSE).
