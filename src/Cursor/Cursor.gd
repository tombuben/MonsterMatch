extends Node2D


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

@export var ShakyHandIntensity: float = 0.1

@export var DynamicSensitivityRange: Vector2 = Vector2(-800, +1800)

# Permutation array for the noise functions
var p : Array[int]

const Tolerance: float = 0.01

var CursorVelocity: Vector2 = Vector2(0, 0)
var MouseDelta: Vector2 = Vector2(0, 0)

var CurrentDynamicSensitivity: float = 0
var DynamicSensitivityTarget: float = 0

var time_passed: float = 0.0
var frequency: float = 0.5
var amplitude: float = 0.01

func noise1d(x):
	# Simple 1D Perlin noise function
	var X = int(x) & 255
	x -= int(x)
	var u = fade(x)
	return lerp(grad(p[X], x), grad(p[X + 1], x - 1), u)

func fade(t):
	return t * t * t * (t * (t * 6 - 15) + 10)

func lerp(t, a, b):
	return a + t * (b - a)

func grad(hashVal, x):
	var h = hashVal & 15
	var grad_val = 1 + (h & 7)  # Gradient value 1-8
	if h & 8:
		grad_val = -grad_val
	return (grad_val * x)

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
	# Initialize permutation array with a fixed seed (you can customize this)
	p.clear()
	for i in range(256):
		p.push_back(i)
	for i in range(256):
		var r = randi() % 256
		var tmp = p[i]
		p[i] = p[r]
		p[r] = tmp

func _input(event):
	if event is InputEventMouseMotion:
		MouseDelta = event.relative
		print(MouseDelta)

func _moveCursor(Velocity: Vector2, Sensitivity: float, DeltaTime: float):
	var CurrentVelocity: Vector2 = Vector2(Velocity.x * Sensitivity * DeltaTime, Velocity.y * Sensitivity * DeltaTime)
	CurrentVelocity = _clampCursorVelocity(CurrentVelocity)
	position += CurrentVelocity
	
	# Clamp to viewport when using controller
	var ViewPortSize : Vector2 = get_viewport().get_visible_rect().size
	position.x = clamp(position.x, 0, ViewPortSize.x)
	position.y = clamp(position.y, 0, ViewPortSize.y)

func _processMouse(DeltaTime: float) -> Vector2:
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
	var UsingMouse: bool = MouseDelta.length() > Tolerance
	
	# Update time based on delta
	time_passed += DeltaTime * frequency

	# Calculate smooth random values using Perlin noise
	var random_x = noise1d(time_passed)
	var random_y = noise1d(time_passed + 1.0)  # Add an offset for different axes

	# Adjust the amplitude to control the strength of the effect
	random_x *= amplitude
	random_y *= amplitude
	
	# TODO keys
	
	var Velocity: Vector2
	if	UsingMouse:
		Velocity = _processMouse(DeltaTime)
	else:
		Velocity = _processController(DeltaTime)
		
	#print(Velocity.length())
		
	if Globals.ShakyHands:
		#Velocity.x += randf_range(-ShakyHandIntensity, +ShakyHandIntensity)
		#Velocity.y += randf_range(-ShakyHandIntensity, +ShakyHandIntensity)
		Velocity.x += random_x
		Velocity.y += random_y

	if Globals.InvertedControls:
		Velocity.x = -Velocity.x
		Velocity.y = -Velocity.y

	var Sensitivity: float = CursorSpeed
	
	if Globals.DynamicSensitivity:
		if	(CurrentDynamicSensitivity - DynamicSensitivityTarget) < Tolerance:
			DynamicSensitivityTarget = randf_range(DynamicSensitivityRange.x, DynamicSensitivityRange.y)
		CurrentDynamicSensitivity = lerp(CurrentDynamicSensitivity, DynamicSensitivityTarget, 5 * DeltaTime)
		#CurrentDynamicSensitivity = ease(CurrentDynamicSensitivity, 2)
		Sensitivity += CurrentDynamicSensitivity
		print(Sensitivity)

	_moveCursor(Velocity, Sensitivity, DeltaTime)
	
	MouseDelta = Vector2(0, 0)
