extends CanvasModulate

@onready var player = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	
func _process(_delta):
	if Input.is_action_just_pressed("LightSwitchToggle"):
		toggle()

func turn_off_lights(flicker : bool = false):
	if flicker == true:
		player.play("LightsOut")
	else:
		visible = false

func turn_on_lights(flicker : bool = false):
	visible = false

func toggle():
	visible = !visible
