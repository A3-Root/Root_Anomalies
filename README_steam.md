[h1]Root's Anomalies - Zeus and 3DEN[/h1]

Zeus and 3DEN modules for spawning supernatural anomalies - environmental hazards with unique mechanics, custom sounds, and effects. Each anomaly behaves differently and can be tuned to fit your mission. Heavily reworked based on Aliascartoon's original concepts.

[b]Current Version:[/b] 6.0.0.0

[b]Required:[/b]
[list]
[*][url=https://steamcommunity.com/workshop/filedetails/?id=450814997/]CBA A3[/url]
[*][url=https://steamcommunity.com/sharedfiles/filedetails/?id=1779063631]Zeus Enhanced (ZEN)[/url]
[/list]

[b]Optional:[/b] [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2797232351]Root's Effects[/url]

[b]Important:[/b] Requires all players to have this addon installed and loaded due to custom textures and sounds.

[img]https://i.imgur.com/EWy3dQc.gif[/img]

Works in single player, hosted multiplayer and on dedicated servers, with or without headless clients. Works out-of-the-box with both Vanilla Medical and ACE Medical, and with or without ACE interaction (sedation and capture use ACE when it is loaded, a hold action otherwise). Useful for Stalker, SCP, Halloween, F.E.A.R, Horror, Sci-Fi, Alien, Anomaly, Prototype, Monster or any other Supernatural themed missions.

[hr]

[h2]Anomalies[/h2]

All anomalies are made with customization in mind. Read through each option to tweak it to your requirements.

Health is calculated by number of hits received from other units. 10 Health = projectile hits required to neutralize the anomaly. Some anomalies have special termination conditions - read them carefully.

[b]Sedation and capture:[/b] throw a sedative smoke (default, or the classes set in the module, e.g. SmokeShellGreen) near an anomaly. It comes out of hiding, freezes in place and cannot hurt anyone, and a [b]Capture Anomaly[/b] action appears (ACE interaction or hold action). After the sedative wears off it stays docile for a cooldown before attacking again. Sedation time and cooldown are set per module.

[h3]Burper Anomaly[/h3]
[img]http://i.imgur.com/0yeQOIv.gif[/img]
[list]
[*]Instantly kills all objects within configured radius.
[*]Visible/detectable only for units with [b]Detection Device[/b] configured. (Default: Vanilla Mine Detector)
[*]Evaded by units wearing [b]Protection Device[b]. (Default: Kitbag (MTP))
[*]Killed/destroyed via configured [b]Killswitch[/b] vehicle within Kill-Range. (Default: CSAT Typhoon Device Truck)
[/list]

[h3]Farmer Anomaly[/h3]
[img]https://i.imgur.com/GTpolsth.gif[/img]
[list]
[*]Travels underground to random target within territory, causes massive shockwave for 25 meters.
[*]Targets ground-based infantry and vehicles.
[*]You hear it rumble along its burrow and blast when it strikes.
[/list]

[h3]Flamer Anomaly[/h3]
[img]http://i.imgur.com/xQlsU22.gif[/img]
[list]
[*]Burns and kills units within territory using fire.
[*]Targets ground and air units.
[*]Does not like water.
[/list]

[h3]Screamer Anomaly[/h3]
[img]http://i.imgur.com/9ZU3G9t.gif[/img]
[list]
[*]Uses high-pitch sound to push back things.
[*]Customizable with custom models (including live AI).
[*]Depending on chosen model - requires Heavy Explosives to neutralize.
[/list]

[h3]Smuggler Anomaly[/h3]
[img]http://i.imgur.com/JGYihwh.gif[/img]
[list]
[*]Teleports/smuggles objects and units to and from random places.
[*]Customizable to spawn random/specific objects including AI.
[*]Spawned AI are [b]always[/b] hostile to players regardless of side.
[*]Visible/detectable only for units with [b]Detection Device[/b] configured. (Default: Vanilla Mine Detector)
[*]Evaded by units wearing [b]Protection Device[b]. (Default: Kitbag (MTP))
[*]Option to turn off [b]Flashing Lights[/b] for players with epilepsy or other conditions.
[*][b][NOTE][/b] - Highly recommended NOT to manually delete the entity after being placed.
[/list]

[h3] Steamer Anomaly
[img]http://i.imgur.com/FN9yRUy.gif[/img]
[list]
[*]Uses underground gas pipes to move to random target within territory and burst out.
[*]Neutralized only by explosives around its location.
[*]Customizable to provide visible pathing to its position for a short period to aid in locating.
[*]Sedative smoke anywhere in its territory forces it to materialise where the smoke landed.
[*]When it dies the ground tears open beneath it, throwing soil, rock, people and vehicles into the air.
[/list]

[h3] Strigoi Anomaly
[img]http://i.imgur.com/t3D4g6A.gif[/img]
[list]
[*]Uses electric current to disorient, confuse, drain stamina, and kill units within territory.
[*]Customizable to only be active during night time.
[*]Option to turn off [b]Flashing Lights[/b] for players with epilepsy or other conditions.
[/list]

[h3] Swarmer Anomaly
[img]http://i.imgur.com/VIYrFKS.gif[/img]
[list]
[*]Deadly flies that leech off nearby units until the unit is dead or away from territory.
[*]Neutralized by throwing configured [b]Pesticide[/b] object (magazine or ammo classname, e.g. SmokeShellRed). The pesticide never counts as a sedative.
[/list]

[h3] Twins Anomaly
[img]http://i.imgur.com/EbXKTPc.gif[/img]
[list]
[*]Plays with the mind and vision of its target - slowly killing them.
[*]Killed by shooting its [b]Heart[b].
[*]Option to turn off [b]Flashing Lights[/b] for players with epilepsy or other conditions.
[/list]

[h3] Worm Anomaly
[img]http://i.imgur.com/ILe4Buj.gif[/img]
[list]
[*]Gaseous entity in the shape of a worm, attacks target by slamming to the ground.
[*]Confuse its target selection by having more than one unit near it and running in different directions.
[*]Neutralized by throwing configured [b]Worm Diffuser[/b] object.
[*]Baited by a thrown [b]Diversion Device[b]: it attacks that spot instead of people for the configured number of attacks, even after the device burns out.
[/list]

[h3] Wraith Anomaly
[list]
[*]Ground-bound stalker stitched together from Strigoi, Flamer and Farmer flesh. Walks while it stalks, runs when it closes in, and claws whoever it reaches. No leaping.
[*]Invisible to the naked eye. It only shows up through [b]night vision[b], [b]thermal[/b] or both (set per module), including vehicle optics and UAV cameras.
[*]A sedated Wraith is visible to everyone so it can be captured.
[/list]

[hr]

[h2]Credits[/h2]
[b]Author:[/b] Root (xMidnightSnowx)
[b]ALIASCARTOONS[/b] — author of the original idea and work. [url=https://steamcommunity.com/id/aliascartoons/myworkshopfiles/]Check out more of his stuff here[/url].
[url=https://77th-jsoc.com][b]77th JSOC[/b][/url]
[hr]
[h2]License[/h2]
[b]APL-SA:[/b] Arma Public License Share Alike
[url=https://www.bohemia.net/community/licenses/arma-public-license-share-alike]Read Full License here[/url]
[img]https://i.postimg.cc/pTxntLMW/APL-SA.png[/img]
You may redistribute the mod publicly only with clear author credit and a link to this Workshop page. Do not redistribute it privately without credit or port it to games other than Arma without explicit permission from me.
[hr]
[h2]Links[/h2]
[url=https://github.com/A3-Root/Root_Anomalies][img]https://i.imgur.com/lPLHihO.gif[/img][/url]
[url=https://discord.gg/77th-jsoc-official][img]https://i.imgur.com/8B7UcQ2.gif[/img][/url]
[hr]
Tags: #Arma 3 #Steam #Workshop #Mod #Root #Script #Zeus #Editor #Eden #Anomalies #SCP #Horror #Monster
Arma3,Anomalies,Horror,SCP,SCP Foundation,Creatures,Monsters,Supernatural,Paranormal,Survival,Zeus,Zeus Enhanced,ZEN,3DEN Editor,Editor Modules,Mission Making,Eden Editor,CBA,ACE3,Multiplayer,Dedicated Server,Coop,Sandbox,AI,Custom Entities,Modular,Immersive,Science Fiction,Containment,Sedation,Capture,Night Vision,Thermal Optics,Psychological Horror,PvE,Mission Framework