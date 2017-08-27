rings_player = {}

rings_player.experience_add = function(player,exp)
	local player_name = player:get_player_name()
	local current_experience = datastorage.key_inc(player_name,'experience',exp)
	local current_level = datastorage.key_get(player_name,'level')

	local level = rings_player.get_level_by_experience(current_experience)
	if current_level ~= level then
		-- level up
		minetest.log('error',player_name..' reached level '..level);
		datastorage.key_set(player_name,'level',level)
	end

	local next_experience = rings_player.get_experience_by_level(current_level + 1)
	minetest.log('error',player_name..' need to get '..next_experience);
end

rings_player.get_level_by_experience = function(experience)
	return math.floor( ( 1 + math.sqrt( 1 + 8 * experience / 100 ) ) / 2 )
end

rings_player.get_experience_by_level = function(level)
	return 0.5 * ( math.pow(level,2) - level ) * 100;
end
