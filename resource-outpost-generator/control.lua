script.on_init(function()
	print('Hello, world! Greets init')
	game.print('Hello, world! Greets init')
end)

script.on_load(function()
	print('Hello, world! Greets load')
end)

local function MPtoStr(MapPosition)
	return MapPosition.x .. ', ' .. MapPosition.y
end

-- startingPositions :: array[MapPosition], endingPositions :: array[MapPosition]
-- returns positions on path: array[MapPositions]
local function bfsWrapper(input)
	local goals = {}
	local startPos = input.startPos
	local endPos = input.endPos
	local surface = input.surface
	table.insert(goals, endPos)
	goals[MPtoStr(endPos)] = true
	print(serpent.block(goals))
	-- queue: array[position, path: string, visited]
	local function bfs(bfsGoals, bfsStartPos, bfsSurface)
		local queue = {}
		table.insert(queue, {position=bfsStartPos, path='', visited={}})
		local directions = { N = {x=0,y=-1}, S = {x=0, y=1}, W = {x=-1,y=0}, E = {x=1,y=0} }
		local currentPath = ''
		local found = false
		while #queue ~= 0 do
			print(serpent.block(queue))

			game.print('new iteration of main while loop')
			local currentPosition = queue[1].position
			local currentVisited = queue[1].visited
			currentPath = queue[1].path
			table.remove(queue, 1)
			if bfsSurface.can_place_entity({ name = 'pipe', position = currentPosition }) then
				game.print(MPtoStr(currentPosition))
				if currentVisited[MPtoStr(currentPosition)] ~= true then
					currentVisited[MPtoStr(currentPosition)] = true
					if bfsGoals[MPtoStr(currentPosition)] then
						found = true
						break
					end
					for dir, vec in pairs(directions) do
						table.insert(queue,{position = {x= currentPosition.x + vec.x, y = currentPosition.y + vec.y},
							path = currentPath .. dir,
							visited = currentVisited
						})
					end
				end
			end
		end
		if found then
			game.print('path found')
			game.print('path is: ' .. currentPath)
		else
			game.print('path not found :(')
		end
	end
	return bfs(goals,startPos,surface)
end

--SHORTCUT EVENTS

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




--SELECTION EVENTS

script.on_event(defines.events.on_player_selected_area, function(event)
	if event.item == "gen-tool" then
		for i, e in ipairs(event.entities) do
			if e.name == "crude-oil" then
				print("build crude-oil outpost at:")
				local x = e.position.x
				local y = e.position.y
				print("x: ", x, " y: ", y)
				game.print("build crude-oil outpost at:")
				game.print("x: " .. x .. " y: " .. y)
				print("crude_oil bounding_box: ", serpent.block(e.bounding_box))

				local pumpjack = {
					name = 'entity-ghost',
					position = e.position,
					force = game.players[event.player_index].force,
					inner_name = 'pumpjack',
					direction = defines.direction.south
				}
				local setting_val = settings.global["AutoBuildOutpost"].value
				print("setting_cal:", setting_val)
				if setting_val == true then
					pumpjack.name = 'pumpjack'
				elseif setting_val == false then
					type(setting_val)
				else
					print("wtf is this bullshit = broekn setting")
				end
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

-- tmp
pastClicks = {}
--OTHER EVENTS

script.on_event("CustomRightClick", function(event)
	local x = event.cursor_position.x
	local y = event.cursor_position.y
	print("Right click registered at: ", "x: " .. x, "y: " .. y)
	game.print("Right click registered")
	bfsWrapper({startPos={x=50.5,y=-394.5}, endPos={x=53.5, y=-390.5}, surface=game.get_surface('nauvis')})
end)
