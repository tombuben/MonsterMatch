extends Node2D

@export var RootNode: Node

@export var UseRightJoy: bool = true
@export var UseLeftJoy: bool = true
@export var UseMouse: bool = true

@export var ControllerUseRK4: bool = true

@export var MouseUseRK4: bool = true
@export var MaxMouseSpeed: float = 1.5
@export var MouseSpeedDivisor: float = 20

@export var CursorDrag: float = 3
@export var CursorSpeed: float = 1200
@export var CursorMaxSpeed: float = 1800

const MouseTestTolerance: float = 0.01

var CursorVelocity: Vector2 = Vector2(0, 0)
var MouseDelta: Vector2 = Vector2(0, 0)

func _clampCursorVelocity(Velocity: Vector2):
	var ClampedVelocity : Vector2
	if Velocity.length() > CursorMaxSpeed:
		ClampedVelocity = Velocity.normalized() * CursorMaxSpeed
	else:
		ClampedVelocity = Velocity

	return ClampedVelocity;

func _rk4(Accel: Vector2, Velocity: Vector2, DeltaTime: float) -> Vector2:
	var A1 = (Accel - CursorDrag * Velocity) * DeltaTime
	var A2 = (Accel - CursorDrag * (Velocity + A1 * 0.5)) * DeltaTime
	var A3 = (Accel - CursorDrag * (Velocity + A2 * 0.5)) * DeltaTime
	var A4 = (Accel - CursorDrag * (Velocity + A3)) * DeltaTime

	var NewAccelerationThisFrame = (A1 + 2.0 * A2 + 2.0 * A3 + A4) / 6.0
	Velocity += NewAccelerationThisFrame
	return Velocity

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		MouseDelta = event.relative

func _moveCursor(Velocity: Vector2, DeltaTime: float):
	var CurrentVelocity: Vector2 = Vector2(Velocity.x * CursorSpeed * DeltaTime, Velocity.y * CursorSpeed * DeltaTime)
	CurrentVelocity = _clampCursorVelocity(CurrentVelocity)
	RootNode.position += CurrentVelocity
	
	# Clamp to viewport when using controller
	var ViewPortSize : Vector2 = get_viewport().size
	RootNode.position.x = clamp(RootNode.position.x, 0, ViewPortSize.x)
	RootNode.position.y = clamp(RootNode.position.y, 0, ViewPortSize.y)

func _processMouse(DeltaTime: float) -> Vector2:
	var MousePos: Vector2 = get_viewport().get_mouse_position()
	var MouseDirection: Vector2 = MouseDelta.normalized()
	var MousePower: float = MouseDelta.length() / MouseSpeedDivisor
	var ClampedMousePower: float = clamp(MousePower, 0, MaxMouseSpeed)
	var MouseVelocity: Vector2 = MouseDirection * ClampedMousePower

	#print(ClampedMousePower)

	if MouseUseRK4:
		CursorVelocity = _rk4(MouseVelocity, CursorVelocity, DeltaTime)
		return CursorVelocity# * MouseVelocityBoost
	else:
		CursorVelocity = Vector2(0, 0)
		return MouseDelta / CursorSpeed / DeltaTime
	
func _processController(DeltaTime: float) -> Vector2:
	var JoyLeft: Vector2  = Input.get_vector("JoyLeftX-", "JoyLeftX+", "JoyLeftY-", "JoyLeftY+")
	var JoyRight: Vector2 = Input.get_vector("JoyRightX-", "JoyRightX+", "JoyRightY-", "JoyRightY+")
	
	var CombinedVector: Vector2 = (JoyLeft + JoyRight)
	var CombinedVectorClamped: Vector2 = Vector2(clamp(CombinedVector.x, -1, 1), clamp(CombinedVector.y, -1, 1))
		
	var CurrentCursorVelocity: Vector2 = Vector2(0, 0)
		
	if	ControllerUseRK4:
		CursorVelocity = _rk4(CombinedVectorClamped, CursorVelocity, DeltaTime)
		CurrentCursorVelocity = CursorVelocity
	else:
		CurrentCursorVelocity = CombinedVectorClamped

	return CurrentCursorVelocity

func _process(DeltaTime: float):
	var UsingMouse: bool = MouseDelta.length() > MouseTestTolerance
	
	# TODO keys
	
	var Velocity: Vector2
	if	UsingMouse:
		Velocity = _processMouse(DeltaTime)
	else:
		Velocity = _processController(DeltaTime)
		
	print(Velocity.length())
		
	_moveCursor(Velocity, DeltaTime)
	
	MouseDelta = Vector2(0, 0)
