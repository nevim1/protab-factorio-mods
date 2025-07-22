EVENTS
================
- on_tick
- on_chunk_generated
- on_gui_XXXXX (Any GUI elements)
- on_mod_item_opened	("Called when the player uses the 'Open item GUI' control on an item defined with the 'mod-openable' flag"}
- on_research_XXXXX (For auto-upgrade of generated structres)
- on_lua_shortcut (For detecting shortcut toggles)

less useful/more random
- -------------------------
- script_raised_XXXXX (Raises a flag to other mods saying out mod preformed a task(like building or destroying something))
- 

PROTOTYPE
================
- ShortcutPrototype (for making our own shortcuts, for more info see docs at Prototype)

CLASSES
================
- LuaTechnology
- LuaGuiElement

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
