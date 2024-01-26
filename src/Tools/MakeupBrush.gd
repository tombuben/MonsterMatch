extends Node2D

@export var brush_stroke_container : Node2D

@onready var line : Line2D = %Line2D
@onready var BRUSH_STROKE : = preload("res://src/Tools/BrushStroke.tscn")

func _ready():
	# TODO: line should be child of some parent node
	line.set_as_top_level(true)


func _process(delta):
	if Input.is_action_pressed("UseToolRight"):
		var brush_stroke : Line2D = BRUSH_STROKE.instantiate()
		brush_stroke_container.add_child(brush_stroke)
		
		brush_stroke.add_point(global_position)

func _on_timer_timeout():
	#var last_point_pos := global_position + line.get_point_position(-1)
	#var pos_diff = global_position.distance_to(last_point_pos)
	#
	#if pos_diff > 10:
	line.add_point(global_position)
