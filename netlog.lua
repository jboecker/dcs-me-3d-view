local base = _G
local require = base.require

module("netlog")

local DST_HOST = "localhost"
local DST_PORT = 46587

local socket = require("socket")
local JSON = base.loadfile("Scripts\\JSON.lua")()
function netlog(obj)
	base.pcall(function()
		local udp = socket.udp()
		udp:settimeout(0)
		udp:setpeername(DST_HOST, DST_PORT)
		udp:send(JSON:encode(obj).."\n\n")
	end)
end
function groupupdate(group)
	if group and group.units then
		local units = {}
		for _, u in base.pairs(group.units) do
			units[#units+1] = {type=u.type, x=u.x, y=u.y, heading=u.heading, unitId=u.unitId}
		end
		netlog({action="group_update", groupId=group.groupId, units=units, category=group.category})
	end
end


-- me_vehicle hooks

function hook_vehicle()

	local vehicle = require("me_vehicle")
	local prevVehicleUpdateHeading = vehicle.updateHeading
	vehicle.updateHeading = function()
		prevVehicleUpdateHeading()
		if vehicle.vdata.group then
			groupupdate(vehicle.vdata.group)
		end
	end

end

-- me_mission hooks

function hook_mission()

	local mission = require("me_mission")
	local prevRemoveGroup = mission.remove_group
	mission.remove_group = function(group)
		netlog({action="remove_group", groupId=group.groupId})
		return prevRemoveGroup(group)
	end
	
	local prevMissionUpdateHeading = mission.updateHeading
	mission.updateHeading = function(group)
		prevMissionUpdateHeading(group)
		groupupdate(group)
	end

end


-- me_map_window hooks
function hook_map_window()
	local map_window = require("me_map_window")
	
	local prevMoveUnit = map_window.move_unit
	map_window.move_unit = function(group, unit, x, y, doNotRedraw)
		prevMoveUnit(group, unit, x, y, doNotRedraw)
		groupupdate(group)
	end
end

function hook_all()
	hook_map_window()
	hook_vehicle()
	hook_mission()
end
