extends TileMap
class_name ValidityMatrix

var desired_map : Array[Vector2i]

func _ready():
	desired_map = get_used_cells(0)
	clear()

func add_cell(pos: Vector2):
	var map_pos : Vector2i = local_to_map(to_local(pos))
	set_cell(0, map_pos, 1, Vector2i(0, 0), 1)
	set_cell(0, map_pos + Vector2i.UP, 1, Vector2i(0, 0), 1)
	set_cell(0, map_pos + Vector2i.DOWN, 1, Vector2i(0, 0), 1)
	set_cell(0, map_pos + Vector2i.LEFT, 1, Vector2i(0, 0), 1)
	set_cell(0, map_pos + Vector2i.RIGHT, 1, Vector2i(0, 0), 1)

func remove_cell(pos: Vector2):
	var map_pos : Vector2i = local_to_map(to_local(pos))
	erase_cell(0, map_pos)
	erase_cell(0, map_pos + Vector2i.UP)
	erase_cell(0, map_pos + Vector2i.DOWN)
	erase_cell(0, map_pos + Vector2i.LEFT)
	erase_cell(0, map_pos + Vector2i.RIGHT)
	#set_cell(0, map_pos, 1, Vector2i(0, 0), 0)
	# Neighbors
	#set_cell(0, map_pos + Vector2i.UP, 1, Vector2i(0, 0), 0)
	#set_cell(0, map_pos + Vector2i.DOWN, 1, Vector2i(0, 0), 0)
	#set_cell(0, map_pos + Vector2i.LEFT, 1, Vector2i(0, 0), 0)
	#set_cell(0, map_pos + Vector2i.RIGHT, 1, Vector2i(0, 0), 0)

func validate_cells():
	var penalization: int = ValidationServer.compare_validation_matrices(desired_map, get_used_cells(0))
	print_debug("Penalization: " + str(penalization))
