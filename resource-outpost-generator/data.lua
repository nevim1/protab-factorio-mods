local outpostGeneratorPrototype = {
	type = "shortcut",
	name = "print-hello-to-console",
	action = "lua",
	icon = "__base__/graphics/icons/shortcut-toolbar/mip/import-string-x56.png",
	small_icon = "__base__/graphics/icons/shortcut-toolbar/mip/import-string-x24.png",
	icon_size = 56,
	small_icon_size = 24
}
data:extend({outpostGeneratorPrototype})

local shortcutProto = data.raw["shortcut"]
print('------------- shortcut dump -------------')
for i, j in pairs(shortcutProto) do
	print(i)
	for k,l in pairs(j) do
		print('+', k,l)
	end
end
print('------------- shortcut dump -------------')
