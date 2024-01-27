extends Sprite2D

@onready var Cursor : Node2D = get_node("/root/Salon/Cursor")
@onready var LeftIris : Node2D = get_node("LeftEye/Iris")
@onready var RightIris : Node2D = get_node("RightEye/Iris")

@onready var LeftEye : Sprite2D = get_node("LeftEye")
@onready var RightEye : Sprite2D = get_node("RightEye")
@onready var Mouth : Sprite2D = get_node("Mouth")

var LeftIrisStartPos : Vector2
var RightIrisStartPos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LeftIrisStartPos = LeftIris.position
	RightIrisStartPos = RightIris.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("LuckaDebugButton"):
		var setup: int = randi() % 3
		print(setup)

		if setup == 0:
			var bakTexture = LeftEye.texture
			LeftEye.texture = Mouth.texture
			Mouth.texture = bakTexture
			LeftEye.remove_child(LeftIris)
			Mouth.add_child(LeftIris)
			var bakNode = Mouth
			Mouth = LeftEye
			LeftEye = bakNode
		elif setup == 1:
			var bakTexture = RightEye.texture
			RightEye.texture = Mouth.texture
			Mouth.texture = bakTexture
			RightEye.remove_child(RightIris)
			Mouth.add_child(RightIris)
			var bakNode = Mouth
			Mouth = RightEye
			RightEye = bakNode
		elif setup == 2:
			pass
	
	#var MousePos: Vector2 = get_viewport().get_mouse_position()
	if Cursor != null:
		var CursorPos: Vector2 = Cursor.global_position
		var LeftToMouse: Vector2 = (LeftIris.global_position - CursorPos).normalized()
		var RightToMouse: Vector2 = (RightIris.global_position - CursorPos).normalized()
		LeftIris.position = LeftIrisStartPos - LeftToMouse * 80
		RightIris.position = RightIrisStartPos - RightToMouse * 120
