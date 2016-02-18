# A 3D View for the DCS: World Mission Editor

This is a quick and dirty hack. A small modification to the DCS: World Mission Editor will send a UDP packet whenever a group is modified. A mission running in a second instance of DCS: World will read that UDP packet and spawn that group into the mission, where you can look at it with the free-roam camera to determine where the unit ends up.

Last tested with DCS: World 1.5.2.49392 and the 2.0.1.49921 Open Alpha.
Setup instructions are the same for 1.5 or 2.0, the only difference is the mission file you run in the "viewer install"

### You need:

* An installation of DCS: World 1.5 or 2.0 Open Alpha
* A second installation of the same DCS: World version (on the same computer or on another computer on your LAN)
* A second monitor or a second computer are extremely useful, but not required

### Setup

This section assumes the following installation locations for your two copies of DCS: World:
* first copy in `C:\Program Files\Eagle Dynamics\DCS World`, using `%USERPROFILE%\Saved Games\DCS`, called the "editor install"
* second copy in `D:\Program Files\Eagle Dynamics\DCS World_D`, using `%USERPROFILE%\Saved Games\DCS.secondcopy_D`, called the "viewer install"
Adapt the paths according to your own situation.

#### Set up the mission editor mod in your "editor install"

* Copy `netlog.lua` to `C:\Program Files\Eagle Dynamics\DCS World\MissionEditor\modules`.
* Open `C:\Program Files\Eagle Dynamics\DCS World\MissionEditor\MissionEditor.lua` and append the following line to the end:
````lua
local netlog = require("netlog"); netlog.hook_all()
````

#### Set up the viewer part in your "viewer install"

* Copy `me_3dview.lua` to `%USERPROFILE%\Saved Games\DCS.secondcopy_D`
* Open the MissionScripting file of your second installation (`D:\Program Files\Eagle Dynamics\DCS World_D\Scripts\MissionScripting.lua`) and add the following lines after `dofile("ScriptingSystem.lua")`:
```lua
me_3dview = {port = 46587}
dofile(lfs.writedir().."me_3dview.lua")
````
* For convenience, you can copy `me-3d-view.miz` (and/or `me-3d-view-nevada.miz`) to the Missions folder of your "viewer install" (`%USERPROFILE%\Saved Games\DCS.secondcopy_D\Missions`)

### How to set up two installations of DCS: World

By default, if you try to start DCS.exe a second time, it will complain about an existing instance and refuse to start. The solution is to have two separate installations.

* To use separate installations on two different computers, edit `DST_HOST` in `netlog.lua` to point to the IP address of the PC that runs the "viewer install"
* To run both instances on the same PC, install DCS: World a second time in another location (takes about 18 GiB). The installer should be smart enough to copy the files from your existing installation instead of downloading them again. Then create or edit the file `dcs_variant.txt` in the installation folder and change the content to something else (I used "secondcopy_D" because I installed it on my D drive). If `dcs_variant.txt` includes the string `foo`, DCS will use `%USERPROFILE%\Saved Games\DCS.foo` as the settings folder.

### How to use

* Run your "viewer install" of DCS and open the `me-3d-view.miz` (for the Caucasus map) or `me-3d-view-nevada.miz` (for the NTTR map) mission
* Run your "editor install" of DCS and use the Mission Editor like you normally would

Units in the Mission Editor should be mirrored in the mission that is running in the "viewer install". Select a unit on the F10 map view and press `F7` to attach the camera to that unit. Then press `Ctrl+F11` to switch to the free-roam camera and position it as required (Mouse Wheel controls movement). Start adding, removing and moving units.

### Bugs

A lot. This is only a very early prototype / proof of concept, and I don't plan to put much effort in further development at least until we know what ED plans for the mission editor. That said, it is already useful for the most common case -- positioning ground units.

* Only vehicle groups have been implemented and (very cursorily) tested
* This probably breaks with very large groups because the data won't fit in a single UDP packet anymore.
* When loading another mission, you may have to restart the me-3d-view.miz mission to get rid of all of the old units.
* In the 3d view, all units show up as blue right now (probably fixable).

### Misc

* If you are running both instances on one PC:
  * set the graphics options on your "viewer install" to the lowest settings to keep things somewhat sane
  * you probably want to set up both versions of DCS so that they use windowed mode with a resolution that is smaller than your monitor. That way, you get two normal windows that you can drag around and easily place side by side or on different monitors.
  * Running both versions of DCS 1.5 in parallel worked file on a machine with 8 GB of RAM, but of course more is better here

### Thanks

I'd like to thank Grimes and Speed for writing the [Mission Scripting Tools](https://github.com/mrSkortch/MissionScriptingTools). Without those, I'd probably still be trying to figure out how to use coalition.addGroup(). The me-3d-view.miz file includes a copy of MiST so it can use mist.scheduleFunction() and mist.dynAdd().

### License
You can redistribute and modify this hack under the terms of the [GNU Lesser General Public License](http://www.gnu.org/licenses/lgpl-3.0.en.html), version 3 or later.

