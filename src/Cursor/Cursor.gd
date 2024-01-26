extends Node2D

@export var CursorSpeed: float = 1200
@export var ControlledByRightJoy: bool = true
@export var ControlledByLeftJoy: bool = true
@export var ControlledByMouse: bool = true
#@export var ControlledByKeys: bool = true
@export var RootNode: Node

var OldMousePos: Vector2 = Vector2(0, 0)
const MouseTestTolerance: float = 0.01

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	var MousePos: Vector2 = get_viewport().get_mouse_position()
	var UsingMouse: bool = (MousePos - OldMousePos).length() > MouseTestTolerance
	OldMousePos = MousePos
	
	var JoyLeft: Vector2  = Input.get_vector("JoyLeftX-", "JoyLeftX+", "JoyLeftY-", "JoyLeftY+")
	var JoyRight: Vector2 = Input.get_vector("JoyRightX-", "JoyRightX+", "JoyRightY-", "JoyRightY+")
	
	# TODO keys
	
	if	UsingMouse:
		RootNode.position = MousePos
	else:
		var FinalVector: Vector2 = (JoyLeft + JoyRight)
		var FinalVectorClamped: Vector2 = Vector2(clamp(FinalVector.x, -1, 1), clamp(FinalVector.y, -1, 1))
	
		RootNode.position.x += FinalVectorClamped.x * CursorSpeed * delta
		RootNode.position.y += FinalVectorClamped.y * CursorSpeed * delta
