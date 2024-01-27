extends Area2D

enum DragableStates {IDLE, FALLING}

var state : DragableStates = DragableStates.IDLE
var grav_accel : float = 30

func _physics_process(delta):
	match state:
		DragableStates.IDLE:
			pass
		DragableStates.FALLING:
			
			position += Vector2.DOWN * grav_accel * delta
			
			grav_accel += 2 * grav_accel * delta


func _on_fall_check_area_entered(area):
	state = DragableStates.FALLING
