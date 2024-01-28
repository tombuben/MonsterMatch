extends Area2D

enum DragableStates {FREE, PLACED}

@export var state : DragableStates = DragableStates.PLACED

func _physics_process(delta):
	match state:
		DragableStates.FREE:
			scale = Vector2(1, 1)
		DragableStates.PLACED:
			scale = Vector2(0.5, 0.5)

func _on_place_check_area_entered(area):
	state = DragableStates.PLACED


func _on_place_check_area_exited(area):
	state = DragableStates.FREE
