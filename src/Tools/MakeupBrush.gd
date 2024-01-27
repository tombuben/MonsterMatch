extends Node2D

@export var brush_stroke_container : Node2D
@export var point_distance_diff : float = 10
@export var draw_area : Polygon2D

@export var is_erase_brush : bool

@onready var BRUSH_STROKE : = preload("res://src/Tools/BrushStroke.tscn")

var last_brush_stroke : Line2D

enum {IDLE, DRAWING, ERASING}
var brush_state = IDLE

var last_point_pos : Vector2

const tolerance : float = 10

func _isPointCloseToCursor(pointPos: Vector2):
	return pointPos.distance_to(global_position) < tolerance

func _process(delta):
	if Input.is_action_pressed("LuckaSwapMakeupBrush"):
		is_erase_brush = not is_erase_brush
	
	match brush_state:
		IDLE:
			if Input.is_action_just_pressed("UseToolRight"):
				if Geometry2D.is_point_in_polygon(global_position, draw_area.polygon):
					if is_erase_brush:
						brush_state = ERASING
					else:
						last_brush_stroke = BRUSH_STROKE.instantiate()
						brush_stroke_container.add_child(last_brush_stroke)
					
						last_brush_stroke.add_point(global_position)
						last_brush_stroke.add_point(global_position + Vector2.RIGHT)
					
						last_point_pos = global_position
				
						brush_state = DRAWING
		DRAWING:
			if !Geometry2D.is_point_in_polygon(global_position, draw_area.polygon):
				last_brush_stroke = BRUSH_STROKE.instantiate()
				brush_stroke_container.add_child(last_brush_stroke)
				return
			
			if last_point_pos.distance_to(global_position) > point_distance_diff:
				last_brush_stroke.add_point(global_position)
				last_point_pos = global_position
				
			if Input.is_action_just_released("UseToolRight"):
				last_brush_stroke.add_point(global_position)
				last_brush_stroke.add_point(global_position + Vector2.RIGHT)

				brush_state = IDLE
		ERASING:
			if !Geometry2D.is_point_in_polygon(global_position, draw_area.polygon):
				return

			var closest_brush_stroke
			var closest_point_index : int = -1

			var breaking: bool = false
			var brush_strokes = brush_stroke_container.get_children()
			for brush_stroke in brush_strokes:
				for i in len(brush_stroke.points):
					if _isPointCloseToCursor(brush_stroke.points[i]):
						closest_brush_stroke = brush_stroke
						closest_point_index = i
						breaking = true
						break
					if breaking:
						break
				
			if closest_brush_stroke != null:
				if len(closest_brush_stroke.points) == 1:
					brush_stroke_container.remove_child(closest_brush_stroke)
					return
				elif len(closest_brush_stroke.points) == 2:
					closest_brush_stroke.remove_point(closest_point_index)
					return
				
				var left_brush_stroke = BRUSH_STROKE.instantiate()
				brush_stroke_container.add_child(left_brush_stroke)
				
				var right_brush_stroke = BRUSH_STROKE.instantiate()
				brush_stroke_container.add_child(right_brush_stroke)
					
				for i in len(closest_brush_stroke.points):
					if i < closest_point_index:
						left_brush_stroke.add_point(closest_brush_stroke.points[i])
					elif i > closest_point_index:
						right_brush_stroke.add_point(closest_brush_stroke.points[i])
						
				brush_stroke_container.remove_child(closest_brush_stroke)

			if Input.is_action_just_released("UseToolRight"):
				brush_state = IDLE

