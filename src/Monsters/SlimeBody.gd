extends Sprite2D

@onready var Cursor : Node2D = get_node("/root/Salon/Cursor")
@onready var LeftIris : Node2D = get_node("LeftEyeSlot/LeftEye/Open/Iris")
@onready var RightIris : Node2D = get_node("RightEyeSlot/RightEye/Open/Iris")

@onready var LeftEye : Sprite2D = get_node("LeftEyeSlot/LeftEye")
@onready var RightEye : Sprite2D = get_node("RightEyeSlot/RightEye")
@onready var Mouth : Sprite2D = get_node("MouthSlot/Mouth")
@onready var LeftArm : Node2D = get_node("ArmLeftSlot/LeftArm")
@onready var RightArm : Node2D = get_node("ArmRightSlot/RightArm")


var LeftIrisStartPos : Vector2
var RightIrisStartPos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LeftIrisStartPos = LeftIris.position
	RightIrisStartPos = RightIris.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("LuckaDebugButton"):
		var setup: int = randi() % 4
		print(setup)

		if setup == 0:
			var leftEyeParent = LeftEye.get_parent()
			leftEyeParent.remove_child(LeftEye)
			var mouthParent = Mouth.get_parent()
			mouthParent.remove_child(Mouth)
			mouthParent.add_child(LeftEye)
			leftEyeParent.add_child(Mouth)
		elif setup == 1:
			var rightEyeParent = RightEye.get_parent()
			rightEyeParent.remove_child(RightEye)
			var mouthParent = Mouth.get_parent()
			mouthParent.remove_child(Mouth)
			mouthParent.add_child(RightEye)
			rightEyeParent.add_child(Mouth)
		elif setup == 2:
			var rightEyeParent = RightEye.get_parent()
			rightEyeParent.remove_child(RightEye)
			var leftArmParent = LeftArm.get_parent()
			leftArmParent.remove_child(LeftArm)
			leftArmParent.add_child(RightEye)
			rightEyeParent.add_child(LeftArm)
		elif setup == 3:
			pass
	
	#var MousePos: Vector2 = get_viewport().get_mouse_position()
	if Cursor != null:
		var CursorPos: Vector2 = Cursor.global_position
		var LeftToMouse: Vector2 = (LeftIris.global_position - CursorPos).normalized()
		var RightToMouse: Vector2 = (RightIris.global_position - CursorPos).normalized()
		LeftIris.position = LeftIrisStartPos - LeftToMouse * 80
		RightIris.position = RightIrisStartPos - RightToMouse * 120
