extends Node2D

@export var speed : float = 45

@export var photoFrames : Array[TextureRect]

# Called when the node enters the scene tree for the first time.
func _ready():
	for frameIndex in len(photoFrames):
		if (frameIndex < len(Globals.screenshots)):
			var photo = Globals.screenshots[frameIndex]
			var texture = ImageTexture.create_from_image(photo)
			photoFrames[frameIndex].texture = texture
			
	await get_tree().create_timer(70.0).timeout
	get_tree().change_scene_to_file("res://src/TitleScreen/TitleScreen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector2.UP * delta * speed)
