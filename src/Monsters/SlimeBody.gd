extends Sprite2D

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
	
	await get_tree().create_timer(3.0).timeout
	get_node("/root/Salon/LightsOut").turn_off_lights(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
	
	var CursorPos: Vector2 = Vector2(0, 0)
	var Cursor : Node2D = get_node_or_null("/root/Salon/Cursor")
	if Cursor != null:
		CursorPos = Cursor.global_position
	else:
		CursorPos = get_viewport().get_mouse_position()
		
	var LeftToMouse: Vector2 = (LeftIris.global_position - CursorPos)
	if LeftToMouse.length() > 40:
		var LeftToMouseNormalized: Vector2 = LeftToMouse.normalized()
		LeftIris.position = LeftIrisStartPos - LeftToMouseNormalized * 80
	
	var RightToMouse: Vector2 = (RightIris.global_position - CursorPos)
	if RightToMouse.length() > 40:
		var RightToMouseNormalized: Vector2 = RightToMouse.normalized()
		RightIris.position = RightIrisStartPos - RightToMouseNormalized * 120
