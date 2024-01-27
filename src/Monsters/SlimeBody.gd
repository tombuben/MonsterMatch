extends Sprite2D

@onready var LeftIris : Node2D = get_node("LeftEye/Iris")
@onready var RightIris : Node2D = get_node("RightEye/Iris")

var LeftIrisStartPos : Vector2
var RightIrisStartPos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LeftIrisStartPos = LeftIris.position
	RightIrisStartPos = RightIris.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var MousePos: Vector2 = get_viewport().get_mouse_position()
	var LeftToMouse: Vector2 = (LeftIris.global_position - MousePos).normalized()
	var RightToMouse: Vector2 = (RightIris.global_position - MousePos).normalized()
	LeftIris.position = LeftIrisStartPos + LeftToMouse * 60
	RightIris.position = RightIrisStartPos + RightToMouse * 60
	pass
