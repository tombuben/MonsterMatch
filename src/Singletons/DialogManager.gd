extends Node


@onready var text_box_scene = preload("res://src/dialogue/text_box.tscn")

var dialog_lines = []
var current_line_index = 0

var text_box
var text_box_position = Vector2(1219,250)
var user_text_box_position = Vector2(138,750)

var is_dialog_active = false
var can_advance_line = false

func start_dialog(position: Vector2, lines: Array):
	if is_dialog_active:
		return
	
	dialog_lines = lines
	#text_box_position = position
	_show_text_box()
	
	is_dialog_active = true
	
func _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	
	match dialog_lines[current_line_index]["speaker"]:
		"char":
			text_box.global_position = text_box_position
		"user":
			text_box.global_position = user_text_box_position
	
	text_box.display_text(dialog_lines[current_line_index]["text"])
	can_advance_line = false
	
func _on_text_box_finished_displaying():
	can_advance_line = true
	await get_tree().create_timer(5.0).timeout
	text_box.queue_free()
	
	current_line_index += 1		
	if current_line_index >= dialog_lines.size():
		is_dialog_active = false
		current_line_index = 0
		return
	
	_show_text_box()
	
#func _unhandled_input(event):
	#if (
		#event.is_action_pressed("ui_select") &&
		#is_dialog_active &&
		#can_advance_line
	#):
		#text_box.queue_free()
	#
		#current_line_index += 1		
		#if current_line_index >= dialog_lines.size():
			#is_dialog_active = false
			#current_line_index = 0
			#return
			#
		#_show_text_box()
	#await get_tree().create_timer(1.0).timeout
	
	
	
	
	
