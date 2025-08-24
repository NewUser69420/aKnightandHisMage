extends Node

var dungeon = Dungeon.new()

@onready var grid_map: GridMap = $GridMap

func _ready():
	if multiplayer.is_server():
		dungeon.generate(5)
	
	var tile_list = dungeon.get_tiles()
	for tile in tile_list:
		var id = tile_list[tile]
		grid_map.set_cell_item(tile, id)
