rings_levels = {}
rings_levels.exp = {}
rings_levels.exp['mobs_mc:wolf'] = 1
rings_levels.exp['mobs_mc:skeleton'] = 10

minetest.after(2.5,function()
	local ents = minetest.registered_entities
	local monsters = {}

	for _,ent in pairs(ents) do 
		if ent.hp_max ~= nil and ent.hp_max > 0 and ent.damage ~= nil and ent.damage > 0 then
			table.insert(monsters,ent)
			print(dump("Adding " .. ent.name .. " to set of monsters."))
		end         
	end

	for _,monster in pairs(monsters) do
		if monster.on_punch ~= nil then
			monster._old_on_punch = monster.on_punch;
		end
		monster.on_punch = function(self,player,tflp,tool_capabilities,dir)
			if self._old_on_punch ~= nil then
				self._old_on_punch(self,player,tflp,tool_capabilities,dir)
			end

			if player and player:is_player() then
				if self.health < 1 then
					minetest.log('error','killed '..self.name,event);

					if rings_levels.exp[self.name] ~= nil then
						rings_player.experience_add(player,rings_levels.exp[self.name]);
					end
				end
				-- print(dump("Monster punched by: " .. player:get_player_name()))
				-- print(dump("Monsters current hitpoints: " .. self.health .. " and max hp was " .. self.hp_max))
			end
		end
	end


end)
