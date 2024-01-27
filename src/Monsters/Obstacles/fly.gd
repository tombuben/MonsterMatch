extends Sprite2D

@export var Speed: float = 2
@export var TowardsMouseSpeed: float = 5
@export var TowardsMouseEndDistance : float = 180
#@export var FleeingTime: float = 0.3
@export var DirectionChangeRange: Vector2 = Vector2(-3, 3)

var TowardsMouse : bool = false

#var TimeSeconds : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	TimeSeconds += delta
	
#	if TimeSeconds > FleeEndTime:
		#Fleeing = false
	
	var CurrentSpeed : float = Speed
	if TowardsMouse:
		CurrentSpeed = TowardsMouseSpeed
	
	var CursorPos: Vector2 = Vector2(0, 0)
	var Cursor : Node2D = get_node_or_null("/root/Salon/Cursor")
	if Cursor != null:
		CursorPos = Cursor.global_position
	else:
		CursorPos = get_viewport().get_mouse_position()
	
	var ToMouse : Vector2 = (CursorPos - global_position)

	if ToMouse.length() > TowardsMouseEndDistance:
		TowardsMouse = false
	if ToMouse.length() < 120:
		TowardsMouse = false
	
	var forward : Vector2
	if TowardsMouse:
		var toMouseVector : Vector2 = ToMouse.normalized()
		rotation_degrees = rad_to_deg(toMouseVector.angle()) + 90
		rotation_degrees += randf_range(DirectionChangeRange.x, DirectionChangeRange.y)
		forward = global_transform.basis_xform(Vector2.UP)
	else:
		rotation_degrees += randf_range(DirectionChangeRange.x, DirectionChangeRange.y)
		forward = global_transform.basis_xform(Vector2.UP)
		
	translate(forward * CurrentSpeed)
	
	var ViewPortSize : Vector2 = get_viewport().get_visible_rect().size
	global_position.x = clamp(global_position.x, 0, ViewPortSize.x)
	global_position.y = clamp(global_position.y, 0, ViewPortSize.y)
	
	if global_position.y < ViewPortSize.y/8.0:
		rotation_degrees += 180.0
		global_position.y += 20
		TowardsMouse = false
	if global_position.y > (ViewPortSize.y - ViewPortSize.y/8.0):
		rotation_degrees += 180.0
		global_position.y -= 20
		TowardsMouse = false
	if global_position.x < ViewPortSize.x/4.0:
		rotation_degrees += 180.0
		global_position.x += 20
		TowardsMouse = false
	if global_position.x > (ViewPortSize.x - ViewPortSize.x/4.0):
		rotation_degrees += 180.0
		global_position.x -= 20
		TowardsMouse = false
		
	if not TowardsMouse:
		if (global_position - CursorPos).length() < 250:
			TowardsMouse = true
		if CursorPos.y < ViewPortSize.y/8.0 or CursorPos.y > (ViewPortSize.y - ViewPortSize.y/8.0):
			TowardsMouse = false
		if CursorPos.x < ViewPortSize.x/4.0 or CursorPos.x > (ViewPortSize.x - ViewPortSize.x/4.0):
			TowardsMouse = false
		
