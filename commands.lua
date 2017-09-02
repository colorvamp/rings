minetest.register_chatcommand("npcs_get", {
	params = "",
	description = "Get npcs status",
	func = function(player_name, param)
		local status = ""
		for name,dummy in pairs(rings_levels.npc) do
			status = datastorage.key_get("___npcs_status",name)
			if status == false then
				status = "unknown"
			end
			minetest.chat_send_player(player_name,name.." is "..status)
		end
		return true, "Done."
	end,
})

minetest.register_chatcommand("ibelieveicanfly", {
	params = "",
	description = "",
	func = function(name, param)
		local privs = minetest.get_player_privs(name)
		privs.fly = true
		minetest.set_player_privs(name, privs)
		return true, "Done."
	end,
})
minetest.register_chatcommand("inoclip", {
	params = "",
	description = "",
	func = function(name, param)
		local privs = minetest.get_player_privs(name)
		privs.noclip = true
		minetest.set_player_privs(name, privs)
		return true, "Done."
	end,
})
minetest.register_chatcommand("giveme", {
	params = "",
	description = "",
	func = function(name, item)
		local player = minetest.get_player_by_name(name)
		player:get_inventory():add_item("main",item)
		return true, "Done."
	end,
})

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

