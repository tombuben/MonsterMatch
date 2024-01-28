extends Node2D

@export var MonsterHolder: Node2D
@export var Scenes : Array[PackedScene] 
@export var CursorScene : PackedScene
@export var DialogueScene : PackedScene
@export var TimerScene : PackedScene

var CurrentSceneIndex : int = 0
@onready var CurrentScene : PackedScene = Scenes[CurrentSceneIndex]

var game_state = Globals.GameStateEnums.INTRO

var Cursor
var Dialogue
var GameTimer

var date_count = 0

var dateTexts = [
	"First",
	"Second",
	"Third",
	"Fourth",
	"Fifth",
	"Sixth",
	"Seventh",
	"Eighth",
	"Ninth"
]

func _doState() -> void:
	match(game_state):
		Globals.GameStateEnums.INTRO:
			if MonsterHolder.get_child_count() > 0:
				var oldMonster = MonsterHolder.get_child(0)
				if oldMonster != null:
					MonsterHolder.remove_child(oldMonster)
			
			var newMoster = CurrentScene.instantiate()
			MonsterHolder.add_child(newMoster)
			
			if (date_count != 0 && date_count % 3 == 0):
				Globals.DateCounter += 1
				
			Dialogue = DialogueScene.instantiate()
			Dialogue.global_position = Vector2(1319,150)
			Dialogue.scale.x = 0.5
			Dialogue.scale.y = 0.5
			%CanvasLayer.add_child(Dialogue)
		Globals.GameStateEnums.MAKEUP:
			if (Globals.CurrentMonster == 0):
				get_node("/root/Salon/LightsOut").turn_off_lights(true)
			Cursor = CursorScene.instantiate()
			Cursor.global_position = Vector2(600, 400)
			add_child(Cursor)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
			GameTimer = TimerScene.instantiate()
			GameTimer.trigger_dialogue.connect(Dialogue._on_timer_scene_trigger_dialogue)
			GameTimer.trigger_gamestate_change.connect(_trigger_state_change)
			add_child(GameTimer)
		Globals.GameStateEnums.OUTRO:
			if (Globals.CurrentMonster == 0):
				get_node("/root/Salon/LightsOut").turn_off_lights(false)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			remove_child(Cursor)
			remove_child(GameTimer)
			Cursor = null
			date_count += 1
			Dialogue._outro()
		Globals.GameStateEnums.INTERMEZZO:
			remove_child(Dialogue)
			remove_child(GameTimer)
			
			if MonsterHolder.get_child_count() > 0:
				var oldMonster = MonsterHolder.get_child(0)
				if oldMonster.has_method("prepare_for_photo"):
					oldMonster.prepare_for_photo()
			# wait frame for remove child to take effect
			await get_tree().process_frame
			var screenshot : Image = get_viewport().get_texture().get_image()
		
			var size = screenshot.get_size().y #square image
			var offset = (screenshot.get_size().x - screenshot.get_size().y) / 2
			var region := Rect2i(offset, 0, size, size)
			var square = screenshot.get_region(region)
			Globals.screenshots.append(square)
			square.resize(400,400)

			$CanvasLayer/Curtain/Label2.text = "The %s Date" % dateTexts[date_count-1]
			$CanvasLayer/Curtain/AnimationPlayer.play("curtain")
			pass
		Globals.GameStateEnums.CREDITS:
			get_tree().change_scene_to_file("res://src/Credits/Credits.tscn")
			pass
	
func _goToNextState() -> void:
	match(game_state):
		Globals.GameStateEnums.INTRO:
			game_state = Globals.GameStateEnums.MAKEUP
			Globals.CurrentGameState = game_state
		Globals.GameStateEnums.MAKEUP:
			game_state = Globals.GameStateEnums.OUTRO
			Globals.CurrentGameState = game_state
		Globals.GameStateEnums.OUTRO:
			game_state = Globals.GameStateEnums.INTERMEZZO
			Globals.CurrentGameState = game_state
		Globals.GameStateEnums.INTERMEZZO:
			if CurrentSceneIndex < len(Scenes) - 1:
				CurrentSceneIndex += 1
				CurrentScene = Scenes[CurrentSceneIndex]
				game_state = Globals.GameStateEnums.INTRO
				Globals.CurrentGameState = game_state
			else:
				game_state = Globals.GameStateEnums.CREDITS
				Globals.CurrentGameState = game_state 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.CurrentGameState = game_state
	_doState()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("DebugNextPhase"):
		$CanvasLayer/CountDown/AnimationPlayer.play("RESET")
		$CanvasLayer/Curtain/AnimationPlayer.play("RESET")
		Dialogue._skip_dialogue()
		_goToNextState()
		_doState()
		
func _trigger_state_change() -> void:
	_goToNextState()
	_doState()

func _countdown():	
	$CanvasLayer/CountDown/AnimationPlayer.play("countdown")

