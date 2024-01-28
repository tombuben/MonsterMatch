extends Node2D

@export var gamepadHint : TextureRect
@export var keyboardHint : TextureRect

var showing_keyboard : bool

func refresh_icons():
	gamepadHint.visible = !showing_keyboard
	gamepadHint.visible = showing_keyboard

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_icon(is_keyboard : bool):
	if is_keyboard != showing_keyboard:
		is_keyboard = showing_keyboard
		refresh_icons

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event is InputEventKey or InputEventMouse:
		set_icon(true)
	if event is InputEventJoypadButton or InputEventJoypadMotion:
		set_icon(false)

