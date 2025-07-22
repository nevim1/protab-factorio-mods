script.on_init(function()
	print('Hello, world! Greets init')
	game.print('Hello, world! Greets init')
end)

script.on_load(function()
	print('Hello, world! Greets load')
	--game.print('Hello, world! Greets load')
end)

script.on_event(defines.events.on_tick, function(event)
	game.print(event.tick)
end)
