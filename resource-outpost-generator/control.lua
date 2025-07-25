--:require("math")

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

local function bfsWrapper(input)
	local goals = {}
	local endPos = input.endPos
	print("endPos: ", serpent.block(endPos))
	local surface = input.surface
	goals[MPtoStr(endPos)] = true
	print(serpent.block(goals))
	local player = input.player

	local function bfs(pumpjacks)
		local occupied = {}
		for _,pumpjack in ipairs(pumpjacks) do
			print(pumpjack)
			for _, pos in ipairs({{x=0,y=0},{x=1,y=0},{x=1,y=1},{x=0,y=1},{x=-1,y=1},{x=-1,y=0},{x=-1,y=-1},{x=0,y=-1},{x=1,y=-1}}) do
				local newPos = {x = pumpjack.position.x + pos.x, y = pumpjack.position.y + pos.y}
				occupied[MPtoStr(newPos)] = true
				surface.create_entity({name='entity-ghost', position = {x = pumpjack.position.x + pos.x, y = pumpjack.position.y + pos.y}, inner_name='transport-belt', force='player'})
			end
		end

		print('occupied: ' , serpent.block(occupied))
		print('goals: ', serpent.block(goals))
		local directions = {{ x = 0, y = -1 }, { x = 0, y = 1 }, { x = -1, y = 0 }, { x = 1, y = 0 }}
		for _,pumpjack in ipairs(pumpjacks) do
			local queue = {}
			for dir,offset in pairs({east = {x=2,y=-1}, north = {x=1,y=-2}, west = {x=-2,y=1}, south = {x=-1,y=2}}) do
				--surface.create_entity({name='entity-ghost', position = {x = pumpjack.position.x + offset.x, y = pumpjack.position.y + offset.y}, inner_name='transport-belt', force='player'})
				table.insert(queue, { position = {x = pumpjack.position.x + offset.x, y = pumpjack.position.y + offset.y}, path = {}, visited = {}, pumpjackDirection = dir })
			end
			print('queue: ', serpent.block(queue))
			local currentPath = {}
			local currentVisited = {}
			local currentPDir = ''
			local found = false
			local index = 1
			local prevTile = {}


			while #queue ~= index do
				print('index: ', index)
				print('queue length: ', #queue)
				--print('queue: ', serpent.block(queue))
				game.print('new iteration of main while loop')
				if index == settings.get_player_settings(player)["bfsMaxDepth"].value then
					game.print("Exceeded bfsMaxDepth, skipping pumpjack")
					break
				end
				local currentPosition = queue[index].position
				currentVisited = queue[index].visited
				currentPDir = queue[index].pumpjackDirection
				currentPath = queue[index].path
				index = index + 1

				table.insert(currentPath, currentPosition)

				if surface.can_place_entity({ name = 'pipe', position = currentPosition }) then
					local StrPos = MPtoStr(currentPosition)
					if not occupied[StrPos] then
						game.print(StrPos)
						if currentVisited[StrPos] ~= true then
							currentVisited[StrPos] = true
							if goals[StrPos] then
								found = currentPosition
								break
							end
							for _, vec in ipairs(directions) do
								print('for ran at least once')
								print('currentVisited: ', serpent.block(currentVisited))
								local newPos = { x = currentPosition.x + vec.x, y = currentPosition.y + vec.y }
								if not currentVisited[MPtoStr(newPos)] then
									print('check passed')
									table.insert(queue, {
										position = newPos,
										path = currentPath,
										visited = currentVisited,
										pumpjackDirection = currentPDir
									})
									prevTile[MPtoStr(newPos)] = currentPosition
								end
							end
						end
					end
				end
			end
			if found then
				game.print('path found')
				print(currentPDir)
				--return currentPath
				local pipes = {}
				local tile = found
				local i = 0
				while tile ~= nil do
					i = i + 1
					if i == 500 then
						break
					end
					print(tile)
					table.insert(pipes, tile)
					tile = prevTile[MPtoStr(tile)]
				end
				return pipes
			else
				game.print('path not found :(')
			end
		end
	end
	return bfs
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



--tmp
local lastPumpjacksSelection = {}
--SELECTION EVENTS

script.on_event(defines.events.on_player_selected_area, function(event)
	lastPumpjacksSelection = {}
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
					type(setting_val)				-- this is useless, it's here just to fill the space
				else
					print("wtf is this bullshit = broekn setting")
				end
				if event.surface.can_place_entity(pumpjack) then
					table.insert(lastPumpjacksSelection, event.surface.create_entity(pumpjack))
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
local RightClickTable = {}
script.on_event("CustomRightClick", function(event)
	local x = event.cursor_position.x
	local y = event.cursor_position.y
	RightClickTable = { ["x"] = x, ["y"] = y }
	print("RightClickTable: ", serpent.block(RightClickTable))
	print("Right click registered at: ", "x: " .. x, "y: " .. y)
	game.print("Right click registered")
	local rctx = math.floor(RightClickTable["x"])+0.5
	local rcty = math.floor(RightClickTable["y"])+0.5
	print("rctx: ", rctx, "rcty: ", rcty)
	print('lastPumpjacksSelection', serpent.block(lastPumpjacksSelection))
	local bfs = bfsWrapper({ endPos = { x = rctx, y = rcty}, surface = game.get_surface('nauvis'), player = event.player_index })
	local pipeLocations = bfs(lastPumpjacksSelection)
	local pipe = {name = 'entity-ghost',
		inner_name = 'pipe',
		force = 'player'
	}
	print('output from bfs: ', serpent.block(pipeLocations))
	for _,pos in ipairs(pipeLocations) do
		pipe.position = pos
		game.get_surface('nauvis').create_entity(pipe)
	end
end)
