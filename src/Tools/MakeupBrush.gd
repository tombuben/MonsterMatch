extends Node2D

@export var brush_stroke_container : Node2D

@onready var BRUSH_STROKE : = preload("res://src/Tools/BrushStroke.tscn")

var brush_stroke : Line2D

enum {IDLE, DRAWING}
var brush_state = IDLE


func _process(delta):
	match brush_state:
		IDLE:
			if Input.is_action_just_pressed("UseToolRight"):
				brush_stroke = BRUSH_STROKE.instantiate()
				brush_stroke_container.add_child(brush_stroke)
				
				brush_state = DRAWING
		DRAWING:
			brush_stroke.add_point(global_position)
	
	if Input.is_action_just_released("UseToolRight"):
		brush_state = IDLE
