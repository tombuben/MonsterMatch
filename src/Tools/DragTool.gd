extends Node2D

var highlighted_item : Node2D


enum {IDLE, DRAGGING}
var brush_state = IDLE

@onready var last_position = global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match brush_state:
		IDLE:
			if Input.is_action_just_pressed("UseToolRight") and highlighted_item != null:
				brush_state = DRAGGING
		DRAGGING:
			var translateDelta = global_position - last_position
			highlighted_item.translate(translateDelta)
			if Input.is_action_just_released("UseToolRight"):
				brush_state = IDLE
	
	last_position = global_position;

func _on_area_2d_body_entered(body):
	highlighted_item = body


func _on_area_2d_body_exited(body):
	if brush_state != DRAGGING && body == highlighted_item:
		highlighted_item = null


func _on_area_2d_area_entered(area):
	highlighted_item = area.get_parent()


func _on_area_2d_area_exited(area):
	if brush_state != DRAGGING && area.get_parent() == highlighted_item:
		highlighted_item = null
