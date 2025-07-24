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

-- startingPositions :: array[MapPosition], endingPositions :: array[MapPosition]
-- returns positions on path: array[MapPositions]
--[[
local function bfsWrapper(startingPositions, endingPositions)
	local function bfs(path, visited, position)
		if position in visited then
			return
		end
	end
end
]]
local function MPtoStr(MapPosition)
	return MapPosition.x .. ', ' .. MapPosition.y
end

-- queue: array[position, path: array[position], visited]
local function bfs(path, queue, goals)
	while #queue ~= 0 do
		local currentPosition = queue[0].position
		local visited = queue[0].visited
		queue:remove(0)
		if surface.can_place_entity({name = 'pipe', position = currentPosition}) then
			if visited[MPtoStr(currentPosition)] ~= true then
				visited[MPtoStr(currentPosition)] = true
			end
		end
	end
end


script.on_event(defines.events.on_player_selected_area, function(event)
	if event.item == "gen-tool" then
		--print("serpent: ", serpent.block(event.entities))
		--[[	local resources = {
			["coal"] = true,
			["stone"] = true,
			["copper-ore"] = true,
			["crude-oil"] = true
		}]]
		for i, e in ipairs(event.entities) do
			--print(i, e.name, e.gps_tag)
			if e.name == "crude-oil" then
				print("build crude-oil outpost at:")
				x = e.position.x
				y = e.position.y
				print("x: ", x, " y: ", y)
				game.print("build crude-oil outpost at:")
				game.print("x: " .. x .. " y: " .. y)
				print("crude_oil bounding_box: ", serpent.block(e.bounding_box))
				--game.print("bounding_box: ".. e.bounding_box)
				pumpjack = {
					name = 'entity-ghost',
					position = e.position,
					force = game.players[event.player_index].force,
					inner_name = 'pumpjack',
					direction = defines.direction.south
				}
				if event.surface.can_place_entity(pumpjack) then
					event.surface.create_entity(pumpjack)
				end
				for j, _ in pairs(defines.direction) do
					game.print(j)
					print(j, _)
				end
			end
		end
	end
end)


script.on_event(defines.events.on_player_alt_selected_area, function(event)
	if event.item == "gen-tool" then
		for i, j in pairs(event.area) do
			game.print(i)
			game.print(j)
			print(i)
			print(j)
		end
	end
end)
