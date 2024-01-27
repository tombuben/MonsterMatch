extends Node2D

@export var brush_stroke_container : Node2D
@export var point_distance_diff : float = 10
@export var draw_area : Polygon2D

@onready var BRUSH_STROKE : = preload("res://src/Tools/BrushStroke.tscn")

var brush_stroke : Line2D

enum {IDLE, DRAWING}
var brush_state = IDLE

var last_point_pos : Vector2

func _process(delta):
	match brush_state:
		IDLE:
			if Input.is_action_just_pressed("UseToolRight"):
				if Geometry2D.is_point_in_polygon(global_position, draw_area.polygon):
					brush_stroke = BRUSH_STROKE.instantiate()
					brush_stroke_container.add_child(brush_stroke)
					
					brush_stroke.add_point(global_position)
					brush_stroke.add_point(global_position + Vector2.RIGHT)
					
					last_point_pos = global_position
				
				
				brush_state = DRAWING
		DRAWING:
			if !Geometry2D.is_point_in_polygon(global_position, draw_area.polygon):
				brush_stroke = BRUSH_STROKE.instantiate()
				brush_stroke_container.add_child(brush_stroke)
				return
			
			if last_point_pos.distance_to(global_position) > point_distance_diff:
				brush_stroke.add_point(global_position)
				last_point_pos = global_position
				
			if Input.is_action_just_released("UseToolRight"):
				brush_stroke.add_point(global_position)
				brush_stroke.add_point(global_position + Vector2.RIGHT)

				brush_state = IDLE

