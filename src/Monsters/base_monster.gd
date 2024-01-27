extends Node2D

@export var BrushContainer : Node2D
@export var DrawArea : Polygon2D

@onready var DrawValidityMatrix : ValidityMatrix = %DrawValidityMatrix

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.BrushContainer = BrushContainer
	Globals.DrawArea = DrawArea
	Globals.DrawValidityMatrix = DrawValidityMatrix


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#DEBUG
	if Input.is_action_just_pressed("ui_accept"):
		DrawValidityMatrix.validate_cells()
