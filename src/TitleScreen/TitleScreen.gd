extends Control

@export var next_level: PackedScene

@onready var play_button : Button = %Play

func _ready():
	play_button.grab_focus()

func _on_play_pressed():
	get_tree().change_scene_to_packed(next_level)


func _on_quit_pressed():
	get_tree().quit()
