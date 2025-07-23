script.on_init(function()
	print('Hello, world! Greets init')
	game.print('Hello, world! Greets init')
end)

script.on_load(function()
	print('Hello, world! Greets load')
end)

script.on_event(defines.events.on_lua_shortcut, function(event)
	if event.prototype_name == 'gen-shortcut' then
		game.print('hello from our shortcut')
		for i, j in pairs(event) do
			print(i, j)
			game.print(i .. ': ' .. j)
		end
		local player = game.players[event.player_index]
		player.cursor_stack.set_stack { name = "gen-tool", count = 1 }
	end
end)

script.on_event(defines.events.on_player_selected_area, function(event)
	if event.item == "gen-tool" then
		--print("serpent: ", serpent.block(event.entities))
		local resources = {
			["coal"] = true,
			["stone"] = true,
			["copper-ore"] = true,
			["crude-oil"] = true
		}
		for i, e in ipairs(event.entities) do
			print(i, e.name, e.gps_tag)
		end
	end
end)
