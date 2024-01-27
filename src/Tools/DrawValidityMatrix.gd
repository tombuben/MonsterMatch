extends TileMap
class_name ValidityMatrix


#func _process(delta):
	#if Input.is_action_pressed("UseToolRight"):
		#add_cell(get_global_mouse_position())


func add_cell(pos: Vector2):
	var map_pos : Vector2i = local_to_map(to_local(pos))
	set_cell(0, map_pos, 1, Vector2i(0, 0), 1)
	
