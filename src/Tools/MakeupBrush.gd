extends Node2D

var brush_stroke_container : Node2D
@export var point_distance_diff : float = 10
var draw_area : Polygon2D
var validity_matrix : ValidityMatrix

@export var is_erase_brush : bool

@export var BRUSH_STROKE : PackedScene

var last_brush_stroke : Line2D

enum {IDLE, DRAWING, ERASING}
var brush_state = IDLE

var last_point_pos : Vector2

const tolerance : float = 10

func _ready() -> void:
	brush_stroke_container = Globals.BrushContainer
	draw_area = Globals.DrawArea
	validity_matrix = Globals.DrawValidityMatrix

func _isPointCloseToCursor(pointPos: Vector2):
	var drawing_position = brush_stroke_container.get_global_transform().affine_inverse() * global_position
	return pointPos.distance_to(drawing_position) < tolerance

func _process(_delta):
	match brush_state:
		IDLE:
			if Input.is_action_just_pressed("UseToolRight"):
				var local_position = draw_area.get_global_transform().affine_inverse() * global_position
				if Geometry2D.is_point_in_polygon(local_position, draw_area.polygon):
					if is_erase_brush:
						brush_state = ERASING
					else:
						last_brush_stroke = BRUSH_STROKE.instantiate()
						brush_stroke_container.add_child(last_brush_stroke)
					
						var drawing_position = brush_stroke_container.get_global_transform().affine_inverse() * global_position
						
						#Draw logic
						last_brush_stroke.add_point(drawing_position)
						last_brush_stroke.add_point(drawing_position + Vector2.RIGHT)
						validity_matrix.add_cell(global_position)
					
						last_point_pos = drawing_position
				
						brush_state = DRAWING
		DRAWING:
			var local_position = draw_area.get_global_transform().affine_inverse() * global_position
			if !Geometry2D.is_point_in_polygon(local_position, draw_area.polygon):
				last_brush_stroke = BRUSH_STROKE.instantiate()
				brush_stroke_container.add_child(last_brush_stroke)
				return
			
			var drawing_position = brush_stroke_container.get_global_transform().affine_inverse() * global_position
			
			if last_point_pos.distance_to(drawing_position) > point_distance_diff:
				#Draw logic 
				last_brush_stroke.add_point(drawing_position)
				last_point_pos = drawing_position
				validity_matrix.add_cell(global_position)
				
			if Input.is_action_just_released("UseToolRight"):
				last_brush_stroke.add_point(drawing_position)
				last_brush_stroke.add_point(drawing_position + Vector2.RIGHT)

				brush_state = IDLE
		ERASING:
			var local_position = draw_area.get_global_transform().affine_inverse() * global_position
			if !Geometry2D.is_point_in_polygon(local_position, draw_area.polygon):
				return

			var closest_brush_stroke
			var closest_point_index : int = -1

			var breaking: bool = false
			var brush_strokes = brush_stroke_container.get_children()
			for brush_stroke in brush_strokes:
				if len(brush_stroke.points) <= 2:
						brush_stroke_container.remove_child(brush_stroke)
						continue
				for i in len(brush_stroke.points):
					if _isPointCloseToCursor(brush_stroke.points[i]):
						closest_brush_stroke = brush_stroke
						closest_point_index = i
						breaking = true
						break
					if breaking:
						break
				
			if closest_brush_stroke != null:
				if len(closest_brush_stroke.points) <= 3:
					brush_stroke_container.remove_child(closest_brush_stroke)
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
			
			validity_matrix.remove_cell(global_position)

			if Input.is_action_just_released("UseToolRight"):
				brush_state = IDLE

