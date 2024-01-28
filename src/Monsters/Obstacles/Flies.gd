extends Node2D

@export var FlyScene : PackedScene
@export var TimeToNewFly : float = 5
@export var SpawnPositions : Array[Vector2]

var TimeSeconds : float
var NewFlySpawnedAlready: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	TimeSeconds += delta
	print(TimeSeconds)
	if (TimeSeconds as int) % (TimeToNewFly as int) == 0:
		if not NewFlySpawnedAlready:
			print("nova moucha")
			var newFly = FlyScene.instantiate()
			add_child(newFly)
			var index = randi_range(0, len(SpawnPositions) - 1)
			newFly.global_position = SpawnPositions[index]
			NewFlySpawnedAlready = true
	if (TimeSeconds as int) % (TimeToNewFly as int) == 1:
		NewFlySpawnedAlready = false
		
