extends Sprite2D


const lines: Array[String] = [
	"Hello darling, what a lovely place you have here.",
	"I'!'ve heard such good things, hopefully you live up to your name."
]

var firstEvent = true

func _unhandled_input(event):
	if firstEvent:
		DialogManager.start_dialog(global_position, lines)
		firstEvent = false
