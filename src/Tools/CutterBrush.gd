extends Node2D


enum {IDLE, CUTTING}
var brush_state = IDLE

@onready var last_position : Vector2 = global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func world_cut():
	
	var space_state = get_world_2d().direct_space_state
	
	var parameters = PhysicsShapeQueryParameters2D.new()
	var shape = SegmentShape2D.new()
	shape.a = last_position
	shape.b = global_position
	parameters.shape = shape
	parameters.collide_with_areas = true
	parameters.collide_with_bodies = false

	var result = space_state.intersect_shape(parameters)
	for colliderData in result:
		var collider = colliderData["collider"]
		var parent = collider.get_parent()
		if parent.has_method("cut"):
			parent.cut(last_position, global_position)

func _process(delta):
	match brush_state:
		IDLE:
			if Input.is_action_just_pressed("UseToolRight"):
				brush_state = CUTTING
		CUTTING:
			world_cut()
	
	if Input.is_action_just_released("UseToolRight"):
		brush_state = IDLE
		
	last_position = global_position

