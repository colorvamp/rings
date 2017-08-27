rings_hud = {
	 players = {}
	,band = {}
}

rings_hud.register = function(player)
	-- Replace hud
	local huds = player:hud_get_flags();
	local player_name = player:get_player_name()

	if huds.healthbar then
		player:hud_remove("healthbar")
	end

	rings_hud.players[player_name] = {}
	rings_hud.players[player_name].band_top = 40;
	rings_hud.players[player_name].band = {};

	local position  = {x = 0,y = 1}
	local alignment = {x = 1,y = 1}
	player:hud_add({
		hud_elem_type = "image",
		position = position, -- position against the screen
		text = "hudbars_bar_background.png",
		number = 2,
		direction = 0,
		alignment = alignment,
		offset = {x = 10,y = -120}, -- offset counting from screen corner
		scale = {x = 1,y = 1},
		size = {x = 16,y = 16}
	})
	rings_hud.players[player_name].health = player:hud_add({
		hud_elem_type = "image",
		position = position,
		text = "hudbars_bar_health.png",
		direction = 0,
		alignment = alignment,
		offset = {x = 11,y = -119},
		scale = {x = 80,y = 1},
		size = {x = 16,y = 16}
	})
	player:hud_add({
		hud_elem_type = "text",
		position = position,
		text = "Health",
		number = 0xFFFFFF,
		alignment = alignment,
		offset = {x = 12, y = -120},
	})

	minetest.after(0, function(player)
		-- Needs a bit of delay for loading
		rings_hud.update_health(player)
	end,player)

	-- Log other players
	for _,_player in ipairs(minetest.get_connected_players()) do
		rings_hud.band.register(player,_player)
	end
end

rings_hud.unregister = function(player)
	local player_name = player:get_player_name()
	rings_hud.players[player_name] = nil

	for _,_player in ipairs(minetest.get_connected_players()) do
		if _player ~= player then 
			rings_hud.band.unregister(_player,player)
		end
	end
end

rings_hud.band.register = function(player,mate)
	local player_name = player:get_player_name()
	if player_name == "" then
		return false
	end
	local mate_name = mate:get_player_name()
	rings_hud.players[player_name].band[mate_name] = {};

	local top = rings_hud.players[player_name].band_top
	local alignment = {x = 1,y = 1}
	local position  = {x = 1,y = 0}
	rings_hud.players[player_name].band[mate_name].face
	 = player:hud_add({
		hud_elem_type = "image",
		position = position,
		text = "hud.avatar.default.png",
		number = 2,
		direction = 0,
		alignment = alignment,
		offset = {x = -192,y = top + 1},
		scale = {x = 0.16,y = 0.16},
		size = {x = 16,y = 16}
	})
	rings_hud.players[player_name].band[mate_name].bg
	 = player:hud_add({
		hud_elem_type = "image",
		position = position,
		text = "hudbars_bar_background.png",
		number = 2,
		direction = 0,
		alignment = alignment,
		offset = {x = -171,y = top},
		scale = {x = 1,y = 1},
		size = {x = 16,y = 16}
	})
	rings_hud.players[player_name].band[mate_name].bar
	 = player:hud_add({
		hud_elem_type = "image",
		position = position,
		text = "hudbars_bar_health.png",
		direction = 0,
		alignment = alignment,
		offset = {x = -170,y = top + 1},
		scale = {x = 80,y = 1},
		size = {x = 16,y = 16}
	})
	rings_hud.players[player_name].band[mate_name].text
	 = player:hud_add({
		hud_elem_type = "text",
		position = position,
		text = mate_name,
		number = 0xFFFFFF,
		alignment = alignment,
		offset = {x = -168, y = top},
	})

	rings_hud.players[player_name].band_top = top + 20
end

rings_hud.band.unregister = function(player,mate)
	local player_name = player:get_player_name()
	if player_name == "" then
		return false
	end
	local mate_name = mate:get_player_name()

	if rings_hud.players[player_name].band[mate_name] == nil then
		return false
	end

	player:hud_remove(rings_hud.players[player_name].band[mate_name]["bg"])
	player:hud_remove(rings_hud.players[player_name].band[mate_name]["bar"])
	player:hud_remove(rings_hud.players[player_name].band[mate_name]["text"])
	rings_hud.players[player_name].band[mate_name] = nil
end

rings_hud.band.update_health_by_percentage = function(player,mate,perc)
	local player_name = player:get_player_name()
	if player_name == "" then
		return false
	end
	local mate_name = mate:get_player_name()

	if rings_hud.players[player_name].band[mate_name] == nil
	or rings_hud.players[player_name].band[mate_name]["bar"] == nil then
		return false
	end

	player:hud_change(rings_hud.players[player_name].band[mate_name]["bar"],"scale",{x = 80 * perc,y = 1})
end

rings_hud.update_health = function(player)
	local player_name = player:get_player_name()
	if rings_hud.players[player_name] == nil then
		return false
	end

	local hud_max = 80;
	local health = player:get_hp()
	local health_max = math.max(rings.PLAYER_MAX_HP_DEFAULT,
 				math.max(player:get_properties().hp_max, health))
	local perc = health / health_max;
	player:hud_change(rings_hud.players[player_name]["health"],"scale",{x = 80 * perc,y = 1})

	-- update other players hud
	for _,_player in ipairs(minetest.get_connected_players()) do
		--if _player ~= player then 
			rings_hud.band.update_health_by_percentage(_player,player,perc)
		--end
	end
end

minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	if player_name == "" then
		return false
	end

	-- register a new bar in the other players band
	for _,_player in ipairs(minetest.get_connected_players()) do
		if _player ~= player then 
			rings_hud.band.register(_player,player)
		end
	end

	rings_hud.update_health(player)
end)

minetest.register_on_leaveplayer(function(player)
	rings_hud.unregister(player)
end)
