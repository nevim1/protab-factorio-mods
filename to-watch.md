EVENTS
================
- on_tick
- on_chunk_generated
- on_gui_XXXXX (Any GUI elements)
- on_mod_item_opened		("Called when the player uses the 'Open item GUI' control on an item defined with the 'mod-openable' flag"}
- on_research_XXXXX (For auto-upgrade of generated structres)
- on_lua_shortcut (For detecting shortcut toggles)
- on_resource_depleted (For alerting the player that some resource has ran out)

less useful/more random
- -------------------------
- script_raised_XXXXX (Raises a flag to other mods saying out mod preformed a task(like building or destroying something))
- 

PROTOTYPE
================
- ShortcutPrototype (for making our own shortcuts, for more info see docs at Prototype)
- ResourceEnt

CLASSES
================
- LuaTechnology
- LuaGuiElement
- LuaSurface
				- create_entity (This can create ghosts that would be placed onto the surface)

CONCEPTS
================
- GuiElementType
- ChunkPosition
- TechnologyID
- Tile
- TileID
- TilePosition
- SurfaceIdentification
- SurfaceCondition
- ModSetting
- AutoplaceControl
- MineableProperties
- 
DEFINES
================
- 
