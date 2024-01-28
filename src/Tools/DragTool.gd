extends Node2D

var highlighted_item : Node2D
var dragging_item : Node2D

@export var openSprite : Sprite2D
@export var closedSprite : Sprite2D

enum {IDLE, DRAGGING}
var brush_state = IDLE

@onready var last_position = global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	openSprite.visible = true
	closedSprite.visible = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match brush_state:
		IDLE:
			if Input.is_action_just_pressed("UseToolRight") and highlighted_item != null:
				dragging_item = highlighted_item
				brush_state = DRAGGING
				
				openSprite.visible = false
				closedSprite.visible = true
				
		DRAGGING:	
			if Input.is_action_just_released("UseToolRight") or dragging_item == null:
				brush_state = IDLE
				openSprite.visible = true
				closedSprite.visible = false
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
	highlighted_item = area


func _on_area_2d_area_exited(area):
	if area == highlighted_item:
		highlighted_item = null


func handle_visibility_change(value : bool):
	if Globals.quick_references.has("EmptyKeyHint"):
		Globals.quick_references["EmptyKeyHint"].visible = !value
