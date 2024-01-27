extends Control

@onready var label = $Countdown/Label

var timerStart = 30
var timerCurrent = 0

signal trigger_dialogue()

# Called when the node enters the scene tree for the first time.
func _ready():
	timerCurrent = timerStart
	label.text = str(timerCurrent)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if (timerCurrent > 0):
		#timerCurrent -= 1
		#label.text = str(timerCurrent)

func _on_timer_timeout():
	if (timerCurrent > 0):
		timerCurrent -= 1
		label.text = str(timerCurrent)
	else:
		$Timer.stop()
		print_debug("stop")
		
	_trigger_dialogue_line()
	
func _trigger_dialogue_line():
	if (Globals.DialogueTimeStamps.has(timerCurrent)):
		emit_signal("trigger_dialogue", timerCurrent)
