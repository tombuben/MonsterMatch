extends Node2D

var highlighted_item : Node2D
var dragging_item : Node2D


enum {IDLE, DRAGGING}
var brush_state = IDLE

@onready var last_position = global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match brush_state:
		IDLE:
			if Input.is_action_just_pressed("UseToolRight") and highlighted_item != null:
				dragging_item = highlighted_item
				brush_state = DRAGGING
		DRAGGING:	
			if Input.is_action_just_released("UseToolRight") or dragging_item == null:
				brush_state = IDLE
			else:
				var translateDelta = global_position - last_position
				dragging_item.translate(translateDelta)
	
	last_position = global_position;

func _on_area_2d_body_entered(body):
	highlighted_item = body


func _on_area_2d_body_exited(body):
	if body == highlighted_item:
		highlighted_item = null


func _on_area_2d_area_entered(area):
	highlighted_item = area.get_parent()


func _on_area_2d_area_exited(area):
	if area.get_parent() == highlighted_item:
		highlighted_item = null
