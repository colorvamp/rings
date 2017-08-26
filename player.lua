rings_player = {}

rings_player.experience_add = function(player,exp)
	local player_name = player:get_player_name()
	datastorage.key_inc(player_name,'experience',exp)
end
