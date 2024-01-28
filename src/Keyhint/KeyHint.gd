extends Node2D

@export var gamepadHint : CanvasItem
@export var keyboardHint : CanvasItem

var showing_keyboard : bool = true

func refresh_icons():
	gamepadHint.visible = !showing_keyboard
	keyboardHint.visible = showing_keyboard

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_icons()

func set_icon(is_keyboard : bool):
	if showing_keyboard != is_keyboard:
		showing_keyboard = is_keyboard
		refresh_icons()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event is InputEventKey or event is InputEventMouse:
		set_icon(true)
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		set_icon(false)
