-- Rings test
rings = {
	PLAYER_MAX_HP_DEFAULT = 20
}

local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/datastorage.lua")
dofile(modpath.."/player.lua")
dofile(modpath.."/hud.lua")
dofile(modpath.."/levels.lua")

-- npcs
dofile(modpath.."/npcs/dinieras_ves.lua")

minetest.register_chatcommand("test1", {
	params = "",
	description = "Test 1: Modify player's inventory view",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end
		player:set_inventory_formspec(
				"size[13,7.5]"..
				"image[6,0.6;1,2;player.png]"..
				"list[current_player;main;5,3.5;8,4;]"..
				"list[current_player;craft;8,0;3,3;]"..
				"list[current_player;craftpreview;12,1;1,1;]"..
				"list[detached:test_inventory;main;0,0;4,6;0]"..
				"button[0.5,7;2,1;button1;Button 1]"..
				"button_exit[2.5,7;2,1;button2;Exit Button]"
		)
		return true, "Done."
	end,
})

minetest.register_chatcommand("test2", {
	params = "",
	description = "Test",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end
		player:set_hp(param)
		return true, "Done."
	end,
})

minetest.register_chatcommand("test3", {
	params = "",
	description = "Test",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end
		local pos = player:getpos();
		print(dump("Adding rings:dinieras_ves to set of monsters."))
		minetest.add_entity({x=pos.x + 2, y= pos.y + 2, z= pos.z + 2},"rings:dinieras_ves")
		return true, "Done."
	end,
})

minetest.register_chatcommand("c", {
	params = "",
	description = "Show character form",
	func = function(player_name, param)
		local data = datastorage.get(player_name)
minetest.log('error',player_name..data["experience"]);
		minetest.show_formspec(player_name,"default:character",
				"size[13,7.5]"..

				"image[0,1;1,1;char.level.label.png]"..
				"image[0.9,1;2.9,1;char.level.label.png]"..

				"label[0.3,1.2;"..data["level"].."]"..
				"label[0.3,1.2;"..data["experience"].."]"..

				"image[0,2;4,0.8;char.attrb.label.png]"..
				"image[0,3;4,0.8;char.attrb.label.png]"..
				"image[0,4;4,0.8;char.attrb.label.png]"..
				"image[0,5;4,0.8;char.attrb.label.png]"..

				"label[0.2,2.1;Strength]"..
				"label[0.2,3.1;Dexterity]"..
				"label[0.2,4.1;Vitality]"..
				"label[0.2,5.1;Energy]"..

				"label[2.2,2.1;0]"..
				"label[2.2,3.1;0]"..
				"label[2.2,4.1;0]"..
				"label[2.2,5.1;0]"..

				"button[0.5,7;2,1;button1;Button 1]"..
				"button_exit[2.5,7;2,1;button2;Exit Button]")
		return true, "Done."
	end,
})

minetest.register_chatcommand("get_level", {
	params = "",
	description = "Get player level",
	func = function(player_name, param)
		local player = minetest.get_player_by_name(player_name)
		if not player then
			return false, "Player not found"
		end
		return true, datastorage.data[player_name]["level"]
	end,
})
minetest.register_chatcommand("get_experience", {
	params = "",
	description = "Get player experience",
	func = function(player_name, param)
		local player = minetest.get_player_by_name(player_name)
		if not player then
			return false, "Player not found"
		end
		return true, datastorage.data[player_name]["experience"]
	end,
})

minetest.register_on_joinplayer(function(player)
	if not player:is_player() then
		return false
	end

	local player_name = player:get_player_name()
	local data = datastorage.get(player_name)
	if data == nil then
		data = {}
	end

	-- Check for new variables
	if data["life"] == nil then
		datastorage.key_set(player_name,"life",50)
		data["life"] = 50
	end
	if data["max_life"] == nil then
		datastorage.key_set(player_name,"max_life",50)
		data["max_life"] = 50
	end
	if data["money"] == nil then
		datastorage.key_set(player_name,"money",0)
	end
	if data["level"] == nil then
		datastorage.key_set(player_name,"level",1)
	end
	if data["experience"] == nil then
		datastorage.key_set(player_name,"experience",0)
	end

	--player:set_properties({
	--	hp_max = data["max_life"]
	--})

	rings_hud.register(player)
end)

core.register_playerevent(function(player,event)
	if not player:is_player() then
		return false
	end

	if event == "health_changed" then
		rings_hud.update_health(player)
		--minetest.log("health"..health)
		--minetest.log('error',event);
	end
end)

