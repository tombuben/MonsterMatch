extends Node2D

@export var BrushContainer : Node2D
@export var DrawArea : Polygon2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.BrushContainer = BrushContainer
	Globals.DrawArea = DrawArea


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
