local outpostGeneratorPrototype = {
	type = "shortcut",
	name = "gen-shortcut",
	action = "lua",
	localised_name = { "shortcut.outpostGeneratorPrototype" },
	icon = "__base__/graphics/icons/signal/signal-mining.png",
	small_icon = "__base__/graphics/icons/signal/signal-mining.png",
	icon_size = 64,
	small_icon_size = 24
}
data:extend({ outpostGeneratorPrototype })

local outpostGeneratorToolPrototype = {
	type = "selection-tool",
	name = "gen-tool",
	--action = "lua",
	icon = "__base__/graphics/icons/signal/signal-mining.png",
	icon_size = 64,
	flags = { "only-in-cursor", "not-stackable", "spawnable" },
	auto_recycle = "false",
	subgroup = "tool",
	hidden = true,
	stack_size = 1,
	order = "c[automated-construction]-x",
	draw_label_for_cursor_render = true,
	select = {
		border_color = { 0, 1, 0 },
		mode = { "blueprint", "avoid-rolling-stock", "avoid-vehicle" },
		cursor_box_type = "copy",
		started_sound = { filename = "__core__/sound/blueprint-select.ogg" },
		ended_sound = { filename = "__core__/sound/blueprint-create.ogg" }
	},
	alt_select = {
		border_color = { 0, 0, 1 },
		mode = { "blueprint" },
		cursor_box_type = "copy"
	}
}
data:extend({ outpostGeneratorToolPrototype })
