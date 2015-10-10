# A 3D View for the DCS: World 1.5 Mission Editor

This is a quick and dirty hack in its very early stages. A small modification to the DCS 1.5 Open Beta Mission Editor will send a UDP packet whenever a group is modified. A mission running in DCS 1.2.x will read that UDP packet and spawn that group into the mission, where you can look at it with the free-roam camera to determine where the unit ends up.

### You need:

* DCS: World v1.2.x
* DCS: World v1.5 Open Beta
* Combined Arms (The me-3d-view.miz includes a game master slot. You might be able to do without CA if you add some other unit there, I didn't try.)

### Setup

* Copy `netlog.lua` to `C:\Program Files\Eagle Dynamics\DCS World OpenBeta\MissionEditor\modules`.
* Open `C:\Program Files\Eagle Dynamics\DCS World OpenBeta\MissionEditor\MissionEditor.lua` and append the following line to the end:
````lua
local netlog = require("netlog"); netlog.hook_all()
````

* Copy `me_3dview.lua` to `%USERPROFILE%\Saved Games\DCS`
* Open the MissionScripting file of your 1.2.x installation (`C:\Program Files\Eagle Dynamics\DCS World\Scripts\MissionScripting.lua`) and add the following lines after `dofile("ScriptingSystem.lua")`:
```lua
me_3dview = {port = 46587}
dofile(lfs.writedir().."me_3dview.lua")
````

### How to use

* Run DCS v1.2.x and open the `me-3d-view.miz` mission
* Run DCS 1.5 Open Beta and use the Mission Editor

Units in the Mission Editor should be mirrored in the mission that is running in DCS 1.2.x. Select a unit on the "F10 map" view and press F7 to attach the camera to that unit. Then press Ctrl+F11 to switch to the free-roam camera and position it as required (Mouse Wheel controls movement). Start adding, removing and moving units.

### Bugs

A lot. This is only a very early prototype / proof of concept.

* Only vehicle groups have been implemented and (very cursorily) tested
* Some unit types will not work. This is because the unit types are different between 1.5 and 1.2.x. The script will remove some common prefixes ("APC ", "SAM ", etc.) to convert a 1.5 unit type into a 1.2.x unit type, but that does not always work.
* This probably breaks with very large groups because the data won't fit in a single UDP packet anymore.
* When loading another mission, you may have to restart the me-3d-view.miz mission to get rid of all of the old units.
* In the 3d view, all units show up as blue right now.

### Misc

* If you have a second computer, you can run the 3D view on that. Edit DST_HOST in `netlog.lua` accordingly.
* Running both versions of DCS in parallel works on my machine with 8 GB of RAM. 16 GB probably recommended :)
* You probably want to set up both versions of DCS so that they use windowed mode with a resolution that is smaller than your monitor. That way, you get two normal windows that you can drag around and easily place side by side or on different monitors.
* In the long term, I want to get this working with two instances of DCS 1.5 (or DCS 2.0 when we get there). That would obviously solve the unit type mismatch problem. Unfortunately, DCS 1.5 refuses to start more than one instance, so the only way would be to run it on two computers.
