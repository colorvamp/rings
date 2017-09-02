-- Rings test
rings = {
	PLAYER_MAX_HP_DEFAULT = 20
}

local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/datastorage.lua")
dofile(modpath.."/player.lua")
dofile(modpath.."/hud.lua")
dofile(modpath.."/levels.lua")
dofile(modpath.."/commands.lua")

-- npcs
dofile(modpath.."/npcs/dinieras_ves.lua")


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

