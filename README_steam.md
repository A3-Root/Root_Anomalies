# Root's Anomalies — Zeus and 3DEN

Zeus and 3DEN modules for spawning supernatural anomalies — environmental hazards with unique mechanics, custom sounds, and effects. Each anomaly behaves differently and can be tuned to fit your mission. Heavily reworked based on Aliascartoon's original concepts.

**Current Version:** 5.0.0 — Updated 2026-10-08

**Required:**
* [CBA A3](https://steamcommunity.com/workshop/filedetails/?id=450814997)
* [Zeus Enhanced (ZEN)](https://steamcommunity.com/sharedfiles/filedetails/?id=1779063631)

**Optional:** [Root's Effects](https://steamcommunity.com/sharedfiles/filedetails/?id=2797232351)

> **Important:** Requires all players to have this addon installed and loaded due to custom textures and sounds.

[img]https://i.imgur.com/EWy3dQc.gif[/img]

Works in single player, hosted multiplayer and on dedicated servers, with or without headless clients. Works out-of-the-box with both Vanilla Medical and ACE Medical, and with or without ACE interaction (sedation and capture use ACE when it is loaded, a hold action otherwise). Useful for Stalker, SCP, Halloween, F.E.A.R, Horror, Sci-Fi, Alien, Anomaly, Prototype, Monster or any other Supernatural themed missions.

---

## Anomalies

All anomalies are made with customization in mind. Read through each option to tweak it to your requirements.

Health is calculated by number of hits received from other units. 10 Health = projectile hits required to neutralize the anomaly. Some anomalies have special termination conditions — read them carefully.

**Sedation and capture:** throw a sedative smoke (default, or the classes set in the module, e.g. SmokeShellGreen) near an anomaly. It comes out of hiding, freezes in place and cannot hurt anyone, and a **Capture Anomaly** action appears (ACE interaction or hold action). After the sedative wears off it stays docile for a cooldown before attacking again. Sedation time and cooldown are set per module.

### Burper Anomaly

[img]http://i.imgur.com/0yeQOIv.gif[/img]

* Instantly kills all objects within configured radius.
* Visible/detectable only for units with **Detection Device** configured. (Default: Vanilla Mine Detector)
* Evaded by units wearing **Protection Device**. (Default: Kitbag (MTP))
* Killed/destroyed via configured **Killswitch** vehicle within Kill-Range. (Default: CSAT Typhoon Device Truck)

### Farmer Anomaly

[img]https://i.imgur.com/GTpolsth.gif[/img]

* Travels underground to random target within territory, causes massive shockwave for 25 meters.
* Targets ground-based infantry and vehicles.
* You hear it rumble along its burrow and blast when it strikes.

### Flamer Anomaly

[img]http://i.imgur.com/xQlsU22.gif[/img]

* Burns and kills units within territory using fire.
* Targets ground and air units.
* Does not like water.

### Screamer Anomaly

[img]http://i.imgur.com/9ZU3G9t.gif[/img]

* Uses high-pitch sound to push back things.
* Customizable with custom models (including live AI).
* Depending on chosen model — requires Heavy Explosives to neutralize.

### Smuggler Anomaly

[img]http://i.imgur.com/JGYihwh.gif[/img]

* Teleports/smuggles objects and units to and from random places.
* Customizable to spawn random/specific objects including AI.
* Spawned AI are **always** hostile to players regardless of side.
* Visible/detectable only for units with **Detection Device** configured. (Default: Vanilla Mine Detector)
* Evaded by units wearing **Protection Device**. (Default: Kitbag (MTP))
* Option to turn off **Flashing Lights** for players with epilepsy or other conditions.
* **[NOTE]** — Highly recommended NOT to manually delete the entity after being placed.

### Steamer Anomaly

[img]http://i.imgur.com/FN9yRUy.gif[/img]

* Uses underground gas pipes to move to random target within territory and burst out.
* Neutralized only by explosives around its location.
* Customizable to provide visible pathing to its position for a short period to aid in locating.
* Sedative smoke anywhere in its territory forces it to materialise where the smoke landed.
* When it dies the ground tears open beneath it, throwing soil, rock, people and vehicles into the air.

### Strigoi Anomaly

[img]http://i.imgur.com/t3D4g6A.gif[/img]

* Uses electric current to disorient, confuse, drain stamina, and kill units within territory.
* Customizable to only be active during night time.
* Option to turn off **Flashing Lights** for players with epilepsy or other conditions.

### Swarmer Anomaly

[img]http://i.imgur.com/VIYrFKS.gif[/img]

* Deadly flies that leech off nearby units until the unit is dead or away from territory.
* Neutralized by throwing configured **Pesticide** object (magazine or ammo classname, e.g. SmokeShellRed). The pesticide never counts as a sedative.

### Twins Anomaly

[img]http://i.imgur.com/EbXKTPc.gif[/img]

* Plays with the mind and vision of its target — slowly killing them.
* Killed by shooting its **Heart**.
* Option to turn off **Flashing Lights** for players with epilepsy or other conditions.

### Worm Anomaly

[img]http://i.imgur.com/ILe4Buj.gif[/img]

* Gaseous entity in the shape of a worm, attacks target by slamming to the ground.
* Confuse its target selection by having more than one unit near it and running in different directions.
* Neutralized by throwing configured **Worm Diffuser** object.
* Baited by a thrown **Diversion Device**: it attacks that spot instead of people for the configured number of attacks, even after the device burns out.

### Wraith Anomaly

* Ground-bound stalker stitched together from Strigoi, Flamer and Farmer flesh. Walks while it stalks, runs when it closes in, and claws whoever it reaches. No leaping.
* Invisible to the naked eye. It only shows up through **night vision**, **thermal** or both (set per module), including vehicle optics and UAV cameras.
* A sedated Wraith is visible to everyone so it can be captured.

---

## Credits

Major credits to **ALIASCARTOONS** for his original idea and work. [Check out more of his stuff here.](https://steamcommunity.com/id/aliascartoons/myworkshopfiles/)

---

## License


[img]https://i.imgur.com/jUUdDUu.png[/img]
Open sourced under APL-SA licence. [GitHub](https://github.com/A3-Root/Root_Anomalies)
