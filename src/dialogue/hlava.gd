extends Sprite2D


const lines: Array[String] = [
	"Hello darling, what a lovely place you have here.",
	#"Hello darling, what a lovely place you have here.",
	"I've heard such good things, hopefully you live up to your name.",
	"This is a lot of text to try if the box will resize when there is a lot of text and it is all oer the place"
]

var firstEvent = true

func _unhandled_input(event):
	if DialogManager.is_dialog_active == false:
		DialogManager.start_dialog(global_position, lines)
