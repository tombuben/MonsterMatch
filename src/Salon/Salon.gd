extends Node2D

@export var MonsterHolder: Node2D
@export var Scenes : Array[PackedScene] 
@export var CursorScene : PackedScene

var CurrentSceneIndex : int = 0
@onready var CurrentScene : PackedScene = Scenes[CurrentSceneIndex]

enum { INTRO, MAKEUP, OUTRO, INTERMEZZO, CREDITS }
var game_state = INTRO

var Cursor

func _doState() -> void:
	match(game_state):
		INTRO:
			var oldMonster = MonsterHolder.get_child(0)
			if oldMonster != null:
				MonsterHolder.remove_child(oldMonster)
			
			var newMoster = CurrentScene.instantiate()
			MonsterHolder.add_child(newMoster)
		MAKEUP:
			Cursor = CursorScene.instantiate()
			Cursor.global_position = Vector2(600, 400)
			add_child(Cursor)
		OUTRO:
			remove_child(Cursor)
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
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("DebugNextPhase"):
		_goToNextState()
		_doState()
