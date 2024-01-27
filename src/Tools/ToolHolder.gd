extends Node


@export var up_tool : Node2D
@export var down_tool : Node2D
@export var left_tool : Node2D
@export var right_tool : Node2D

enum direction {UP, DOWN, LEFT, RIGHT}
var current_selection = direction.UP

var up_index = 0
var down_index = 0
var left_index = 0
var right_index = 0

func set_enable(node, value):
	node.process_mode = Node.PROCESS_MODE_INHERIT if value else Node.PROCESS_MODE_DISABLED
	node.visible = value
	
func set_enabled_child(index : int, node : Node2D):
	var children = node.get_children()
	for i in len(children):
		set_enable(children[i], i == index)

func select_up():
	if 	current_selection == direction.UP:
		up_index = (up_index + 1) % up_tool.get_child_count()
	current_selection = direction.UP
	set_enable(up_tool, true)
	set_enable(down_tool, false)
	set_enable(left_tool, false)
	set_enable(right_tool, false)
	set_enabled_child(up_index, up_tool)
	
func select_down():
	if 	current_selection == direction.DOWN:
		down_index = (down_index + 1) % down_tool.get_child_count()
	current_selection = direction.DOWN
	set_enable(up_tool, false)
	set_enable(down_tool, true)
	set_enable(left_tool, false)
	set_enable(right_tool, false)
	set_enabled_child(down_index, down_tool)

func select_left():
	if 	current_selection == direction.LEFT:
		left_index = (left_index + 1) % left_tool.get_child_count()
	current_selection = direction.LEFT
	set_enable(up_tool, false)
	set_enable(down_tool, false)
	set_enable(left_tool, true)
	set_enable(right_tool, false)
	set_enabled_child(left_index, left_tool)
	
func select_right():
	if 	current_selection == direction.RIGHT:
		right_index = (right_index + 1) % right_tool.get_child_count()
	current_selection = direction.RIGHT
	set_enable(up_tool, false)
	set_enable(down_tool, false)
	set_enable(left_tool, false)
	set_enable(right_tool, true)
	set_enabled_child(right_index, right_tool)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	select_up()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("SelectUpTool"):
		select_up()
	
	if Input.is_action_just_pressed("SelectDownTool"):
		select_down()
		
	if Input.is_action_just_pressed("SelectLeftTool"):
		select_left()
		
	if Input.is_action_just_pressed("SelectRightTool"):
		select_right()
