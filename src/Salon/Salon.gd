extends Node2D

@export var MonsterHolder: Node2D
@export var Scenes : Array[PackedScene] 
@export var CursorScene : PackedScene
@export var DialogueScene : PackedScene
@export var TimerScene : PackedScene

var CurrentSceneIndex : int = 0
@onready var CurrentScene : PackedScene = Scenes[CurrentSceneIndex]

enum { INTRO, MAKEUP, OUTRO, INTERMEZZO, CREDITS }
var game_state = INTRO

var Cursor
var Dialogue
var GameTimer

var date_count = 0

func _doState() -> void:
	match(game_state):
		INTRO:
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
		MAKEUP:
			Cursor = CursorScene.instantiate()
			Cursor.global_position = Vector2(600, 400)
			add_child(Cursor)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
			GameTimer = TimerScene.instantiate()
			GameTimer.trigger_dialogue.connect(Dialogue._on_timer_scene_trigger_dialogue)
			GameTimer.trigger_gamestate_change.connect(_trigger_state_change)
			add_child(GameTimer)
		OUTRO:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			remove_child(Cursor)
			remove_child(GameTimer)
			Cursor = null
			date_count += 1
			Dialogue._outro()
		INTERMEZZO:
			remove_child(Dialogue)
			remove_child(GameTimer)
			$CanvasLayer/Curtain/AnimationPlayer.play("curtain")
		CREDITS:
			pass
	
func _goToNextState() -> void:
	match(game_state):
		INTRO:
			game_state = MAKEUP
			Globals.CurrentGameState = game_state
		MAKEUP:
			game_state = OUTRO
			Globals.CurrentGameState = game_state
		OUTRO:
			game_state = INTERMEZZO
			Globals.CurrentGameState = game_state
		INTERMEZZO:
			if CurrentSceneIndex < len(Scenes) - 1:
				CurrentSceneIndex += 1
				CurrentScene = Scenes[CurrentSceneIndex]
				game_state = INTRO
				Globals.CurrentGameState = game_state
			else:
				game_state = CREDITS
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

