extends Node2D

@export var Scenes : Array[PackedScene] 

var CurrentSceneIndex : int = 0
@onready var CurrentScene : PackedScene = Scenes[CurrentSceneIndex]

enum { INTRO, MAKEUP, OUTRO, INTERMEZZO, CREDITS }
var game_state = INTRO

func _goToNextState() -> void:
	match(game_state):
		INTRO:
			game_state = MAKEUP
		MAKEUP:
			game_state = OUTRO
		OUTRO:
			game_state = INTERMEZZO
		INTERMEZZO:
			if CurrentSceneIndex < len(Scenes):
				CurrentSceneIndex += 1
				CurrentScene = Scenes[CurrentSceneIndex]
				game_state = INTRO
			else:
				game_state = CREDITS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Input.is_action_just_pressed("DebugNextPhase")
	
	match(game_state):
		INTRO:
			pass
		MAKEUP:
			pass
		OUTRO:
			pass
		INTERMEZZO:
			pass
		CREDITS:
			pass # open credits level
