extends MarginContainer

const lines: Array[String] = [
	"Hello darling, what a lovely place you have here.",
	"I've heard such good things, hopefully you live up to your name.",
	"This is a lot of text to try if the box will resize when there is a lot of text and it is all oer the place"
]

var LinesTimeStamps = {
	4: ["Line that happens at time 4"],
	11: ["Line that happens at time 11"]
}

var firstEvent = true

var dialogue = []

func _ready():
	Globals.DialogueTimeStamps = LinesTimeStamps
	dialogue = load_dialogues("res://src/dialogue/jsons/orc_1.json")
	print_debug(dialogue[1]["text"])

func load_dialogues(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var finish = json.parse_string(content)
	return finish


func _unhandled_input(event):
	if DialogManager.is_dialog_active == false:
		DialogManager.start_dialog(global_position, dialogue)


func _on_timer_scene_trigger_dialogue(timeStamp: int):
	var line: Array[String]
	line.assign(LinesTimeStamps[timeStamp])
	DialogManager.start_dialog(global_position, line)
