extends Node


@export var up_tool : Node2D
@export var down_tool : Node2D
@export var left_tool : Node2D
@export var right_tool : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	up_tool.process_mode = Node.PROCESS_MODE_DISABLED
	up_tool.visible = false
	down_tool.process_mode = Node.PROCESS_MODE_DISABLED
	down_tool.visible = false
	left_tool.process_mode = Node.PROCESS_MODE_INHERIT
	left_tool.visible = true
	right_tool.process_mode = Node.PROCESS_MODE_DISABLED
	right_tool.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("SelectUpTool"):
		up_tool.process_mode = Node.PROCESS_MODE_INHERIT
		up_tool.visible = true
		down_tool.process_mode = Node.PROCESS_MODE_DISABLED
		down_tool.visible = false
		left_tool.process_mode = Node.PROCESS_MODE_DISABLED
		left_tool.visible = false
		right_tool.process_mode = Node.PROCESS_MODE_DISABLED
		right_tool.visible = false
	
	if Input.is_action_pressed("SelectDownTool"):
		up_tool.process_mode = Node.PROCESS_MODE_DISABLED
		up_tool.visible = false
		down_tool.process_mode = Node.PROCESS_MODE_INHERIT
		down_tool.visible = true
		left_tool.process_mode = Node.PROCESS_MODE_DISABLED
		left_tool.visible = false
		right_tool.process_mode = Node.PROCESS_MODE_DISABLED
		right_tool.visible = false
		
	if Input.is_action_pressed("SelectLeftTool"):
		up_tool.process_mode = Node.PROCESS_MODE_DISABLED
		up_tool.visible = false
		down_tool.process_mode = Node.PROCESS_MODE_DISABLED
		down_tool.visible = false
		left_tool.process_mode = Node.PROCESS_MODE_INHERIT
		left_tool.visible = true
		right_tool.process_mode = Node.PROCESS_MODE_DISABLED
		right_tool.visible = false
		
	if Input.is_action_pressed("SelectRightTool"):
		up_tool.process_mode = Node.PROCESS_MODE_DISABLED
		up_tool.visible = false
		down_tool.process_mode = Node.PROCESS_MODE_DISABLED
		down_tool.visible = false
		left_tool.process_mode = Node.PROCESS_MODE_DISABLED
		left_tool.visible = false
		right_tool.process_mode = Node.PROCESS_MODE_INHERIT
		right_tool.visible = true
