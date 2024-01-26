extends Node2D

@export var IsLeftCursor: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	const CURSOR_SPEED: float = 500
	
	var Joy: Vector2
	if IsLeftCursor:
		Joy = Input.get_vector("JoyLeftX-", "JoyLeftX+", "JoyLeftY-", "JoyLeftY+")
	else:
		Joy = Input.get_vector("JoyRightX-", "JoyRightX+", "JoyRightY-", "JoyRightY+")
	print(Joy)
	
	self.position.x += Joy.x * CURSOR_SPEED * delta
	self.position.y += Joy.y * CURSOR_SPEED * delta
