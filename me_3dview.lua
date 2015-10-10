if not me_3dview then me_3dview = {} end
me_3dview.port = me_3dview.port or 46587

do
	local require = require
	local loadfile = loadfile
	local io = io
	local lfs = lfs
	package.path = package.path..";.\\LuaSocket\\?.lua"
	package.cpath = package.cpath..";.\\LuaSocket\\?.dll"
	local JSON = loadfile("Scripts\\JSON.lua")()
	local socket = require("socket")

	function me_3dview.group_update(groupInfo)
		local groupName = "gn_"..tostring(groupInfo.groupId)

		local unitsTable = {

			["groupId"] = groupInfo.groupId,
			["units"] = 
			{
			}, -- end of ["units"]
			["name"] = groupName,
			["country"] = "USA",
			["category"] = "vehicle"
		}

		for _, u in pairs(groupInfo.units) do
			unitsTable.units[#unitsTable.units+1] = {
				["y"] = u.y,
				["type"] = u.type,
				["unitId"] = u.unitId,
				["heading"] = u.heading,
				["playerCanDrive"] = true,
				["skill"] = "Average",
				["x"] = u.x,
			}
		end


		mist.dynAdd(unitsTable)
	end

	me_3dview.groupActions = {}
	function me_3dview.doGroupActions()
		for _, msg in pairs(me_3dview.groupActions) do
			if msg.action and msg.action == "group_update" then
				me_3dview.group_update(msg) 
			end
			if msg.action and msg.action == "remove_group" then
				Group.getByName("gn_"..tostring(msg.groupId)):destroy() 
			end
		end
		me_3dview.groupActions = {}
		mist.scheduleFunction(me_3dview.doGroupActions, {}, timer.getTime() + .125)
	end

	function me_3dview.onUdpData(d)
		local msg = JSON:decode(d)
		if msg.action and msg.groupId then
			me_3dview.groupActions[msg.groupId] = msg
		end
	end

	function me_3dview.start()
		local udp = socket.udp()
		udp:setsockname("*", me_3dview.port)
		udp:settimeout(0)

		local function udp_step()
			mist.scheduleFunction(udp_step, {}, timer.getTime() + 0.01)
			while true do
				local packet = udp:receive()
				if not packet then return end
				me_3dview.onUdpData(packet)
			end
		end

		mist.scheduleFunction(udp_step, {}, timer.getTime() + 0.1)
		mist.scheduleFunction(me_3dview.doGroupActions, {}, timer.getTime())
	end
end