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
		
	var monster = get_node("/root/Salon/MonsterHolder/Monster/SlimeTopLayers")
	if (monster != null) and monster.has_method("swap_eyes"):
		monster.swap_eyes()

func turn_on_lights(flicker : bool = false):
	visible = false

func toggle():
	if visible:
		turn_off_lights()
	else:
		visible = !visible
