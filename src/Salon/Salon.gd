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

func _doState() -> void:
	match(game_state):
		INTRO:
			if MonsterHolder.get_child_count() > 0:
				var oldMonster = MonsterHolder.get_child(0)
				if oldMonster != null:
					MonsterHolder.remove_child(oldMonster)
			
			var newMoster = CurrentScene.instantiate()
			MonsterHolder.add_child(newMoster)
			
			Dialogue = DialogueScene.instantiate()
			Dialogue.global_position = Vector2(1219,250)
			Dialogue.scale.x = 0.5
			Dialogue.scale.y = 0.5
			add_child(Dialogue)
		MAKEUP:
			Cursor = CursorScene.instantiate()
			Cursor.global_position = Vector2(600, 400)
			add_child(Cursor)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
			GameTimer = TimerScene.instantiate()
			GameTimer.trigger_dialogue.connect(Dialogue._on_timer_scene_trigger_dialogue)
			add_child(GameTimer)
		OUTRO:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			remove_child(Cursor)
			remove_child(GameTimer)
			Cursor = null
		INTERMEZZO:
			pass
		CREDITS:
			pass
	
func _goToNextState() -> void:
	match(game_state):
		INTRO:
			game_state = MAKEUP
		MAKEUP:
			game_state = OUTRO
		OUTRO:
			game_state = INTERMEZZO
		INTERMEZZO:
			if CurrentSceneIndex < len(Scenes) - 1:
				CurrentSceneIndex += 1
				CurrentScene = Scenes[CurrentSceneIndex]
				game_state = INTRO
			else:
				game_state = CREDITS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_doState()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("DebugNextPhase"):
		_goToNextState()
		_doState()
