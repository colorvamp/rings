rings_hud = {
	players = {}
}

rings_hud.register = function(player)
	-- Replace hud
	local huds = player:hud_get_flags();
	local player_name = player:get_player_name()

	if huds.healthbar then
		player:hud_remove("healthbar")
	end

	rings_hud.players[player_name] = {}

	player:hud_add({
		hud_elem_type = "image",
		position = {x = 0,y = 1},
		text = "hudbars_bar_background.png",
		number = 2,
		direction = 0,
		alignment = {x = 1,y = 1},
		offset = {x = 10,y = -120},
		scale = {x = 1,y = 1},
		size = {x = 16,y = 16}
	})
	rings_hud.players[player_name]["health"] = player:hud_add({
		hud_elem_type = "image",
		position = {x = 0,y = 1},
		text = "hudbars_bar_health.png",
		direction = 0,
		alignment = {x = 1,y = 1},
		offset = {x = 11,y = -119},
		scale = {x = 20,y = 1},
		size = {x = 16,y = 16}
	})
	player:hud_add({
		hud_elem_type = "text",
		text = "Health",
		number = 0xFFFFFF,
		alignment = {x = 1,y = 1},
		offset = {x = 12, y = -120},
		position = {x = 0,y = 1},
	})
end

rings_hud.unregister = function(player)
	local player_name = player:get_player_name()
	rings_hud.players[player_name] = nil
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
end


minetest.register_on_leaveplayer(function(player)
	rings_hud.unregister(player)
end)
