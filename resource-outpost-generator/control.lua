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
	print("startPos: ", serpent.block(startPos))
	local endPos = input.endPos
	print("endPos: ", serpent.block(endPos))
	local surface = input.surface
	table.insert(goals, endPos)
	goals[MPtoStr(endPos)] = true
	print(serpent.block(goals))
	local player = input.player
	-- queue: array[position, path: string, visited]
	local function bfs(bfsGoals, bfsStartPos, bfsSurface, bfsPlayer)
		local queue = {}
		table.insert(queue, { position = bfsStartPos, path = '', visited = {} })
		local directions = { N = { x = 0, y = -1 }, S = { x = 0, y = 1 }, W = { x = -1, y = 0 }, E = { x = 1, y = 0 } }
		local currentPath = ''
		local found = false
		local index = 1
		while #queue ~= 0 do
			game.print('new iteration of main while loop')
			local currentPosition = queue[index].position
			local currentVisited = queue[index].visited
			currentPath = queue[index].path
			index = index + 1
			if index == settings.get_player_settings(bfsPlayer)["bfsMaxDepth"].value then
				game.print("Exceeded bfsMaxDepth, stopping action")
				break
			end
			if bfsSurface.can_place_entity({ name = 'pipe', position = currentPosition }) then
				local StrPos = MPtoStr(currentPosition)
				game.print(StrPos)
				if currentVisited[StrPos] ~= true then
					currentVisited[StrPos] = true
					if bfsGoals[StrPos] then
						found = true
						break
					end
					for dir, vec in pairs(directions) do
						table.insert(queue, {
							position = { x = currentPosition.x + vec.x, y = currentPosition.y + vec.y },
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
	return bfs(goals, startPos, surface, player)
end

--SHORTCUT EVENTS

script.on_event(defines.events.on_lua_shortcut, function(event)
	if event.prototype_name == 'gen-shortcut' then
		--	game.print('hello from our shortcut')
		-- for i, j in pairs(event) do
		-- 	print(i, j)
		-- 	game.print(i .. ': ' .. j)
		-- end
		local player = game.players[event.player_index]
		player.cursor_stack.set_stack { name = "gen-tool", count = 1 }
	end
end)



local leftCorner = {}
local rightCorner = {}
--SELECTION EVENTS
script.on_event(defines.events.on_player_selected_area, function(event)
	if event.item == "gen-tool" then
		leftCorner = event.area["left_top"]
		rightCorner = event.area["right_bottom"]
		print("leftCorner: ", serpent.block(leftCorner), "rightCorner: ", serpent.block(rightCorner))
		for _, e in ipairs(event.entities) do
			local pumpjack = {
				name = 'entity-ghost',
				position = e.position,
				force = game.players[event.player_index].force,
				inner_name = 'pumpjack',
				direction = defines.direction.south
			}
			local powerpole = {
				name = "entity-ghost",
				position = leftCorner,
				force = game.players[event.player_index].force,
				inner_name = "small_electric_pole"
			}
			if e.name == "crude-oil" then
				print("build crude-oil outpost at:")
				local x = e.position.x
				local y = e.position.y
				-- print("x: ", x, " y: ", y)
				game.print("build crude-oil outpost at:")
				game.print("x: " .. x .. " y: " .. y)
				print("crude_oil bounding_box: ", serpent.block(e.bounding_box))

				local setting_val = settings.global["AutoBuildOutpost"].value
				-- print("setting_cal:", setting_val)
				if setting_val == true then
					pumpjack.name = 'pumpjack'
					powerpole.name = "small-electric-pole"
				elseif setting_val == false then
					-- nic
				else
					print("wtf is this bullshit = broekn setting")
				end
				if event.surface.can_place_entity(pumpjack) then
					event.surface.create_entity(pumpjack)
				end
				local lx = leftCorner["x"]
				local rx = rightCorner["x"]
				local ry = rightCorner["y"]
				local ly = leftCorner["y"]
				for i = math.min(lx, rx), math.max(rx, lx), 3 do
					for j = math.min(ly, ry), math.max(ry, ly), 3 do
						powerpole.position = { ["x"] = i, ["y"] = j }
						print(serpent.block(powerpole.position))
						if event.surface.can_place_entity(powerpole) then
							event.surface.create_entity(powerpole)
						end
					end
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

--OTHER EVENTS
local CustomPosTable = {}
script.on_event("CustomPosPicker", function(event)
	local playerN = game.get_player(event.player_index)
	local stack = playerN.cursor_stack
	if stack and stack.valid_for_read then
		print("player cursor stack: ", stack.name, "and type: ", type(playerN.cursor_stack))
		if stack.name == "gen-tool" then
			local x = event.cursor_position.x
			local y = event.cursor_position.y
			CustomPosTable = { ["x"] = x, ["y"] = y }
			-- print("CustomPosTable: ", serpent.block(CustomPosTable))
			print("Right click registered at: ", "x: " .. x, "y: " .. y)
			game.print("Custom Click registered")
			local cptx = math.floor(CustomPosTable["x"]) + 0.5
			local cpty = math.floor(CustomPosTable["y"]) + 0.5
			print("cptx: ", cptx, "cpty: ", cpty)
			bfsWrapper({
				startPos = { x = -60.5, y = -350.5 },
				endPos = { x = cptx, y = cpty },
				surface = game.get_surface('nauvis'),
				player = event.player_index
			})
		else
			game.print("Wrong item held")
			print("worng item held")
		end
	else
		game.print("!!STACK EMPTY!!")
		print("stack empty")
	end
end)
