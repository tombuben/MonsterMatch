extends MarginContainer

@onready var text_box_scene = preload("res://src/dialogue/text_box.tscn")

var jsonPath = "res://src/dialogue/jsons/"

var dialog_lines = []
var current_line_index = 0

var text_box
var text_box_position = Vector2(1219,250)
var user_text_box_position = Vector2(138,750)

var is_dialog_active = false
var can_advance_line = false

var LinesTimeStamps = {
	4: ["Line that happens at time 4"],
	11: ["Line that happens at time 11"]
}

var dialogueStart = []
var dialogueMakeup = []
var dialogueEnd = []

var CurrentMonster

func _ready():
	CurrentMonster = Globals.CurrentMonster
	dialogueStart = load_dialogues(jsonPath + "%s_%d.json" % [Globals.MonsterTypeEnum.keys()[CurrentMonster], 1])
	dialogueMakeup = load_dialogues(jsonPath + "%s_makeup_%d.json" % [Globals.MonsterTypeEnum.keys()[CurrentMonster], 1])
	dialogueEnd = load_dialogues(jsonPath + "%s_end_%d.json" % [Globals.MonsterTypeEnum.keys()[CurrentMonster], 1])
	
	for line in dialogueMakeup:
		Globals.DialogueTimeStamps[int(line["time"])] = line["text"]
	
	if is_dialog_active == false:
		start_dialog(global_position, dialogueStart)

func _outro():
		start_dialog(global_position, dialogueEnd)

func load_dialogues(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var finish = json.parse_string(content)
	return finish

func _on_timer_scene_trigger_dialogue(timeStamp: int):
	var lines = [Globals.DialogueTimeStamps[timeStamp]]
	start_dialog(global_position, lines)

func start_dialog(position: Vector2, lines: Array):
	if is_dialog_active:
		return
	
	dialog_lines = lines
	#text_box_position = position
	_show_text_box()
	
	is_dialog_active = true
	
func _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	
	add_child(text_box)
	
	#match dialog_lines[current_line_index]["speaker"]:
		#"char":
			#text_box.global_position = text_box_position
		#"user":
			#text_box.global_position = user_text_box_position
	match Globals.CurrentGameState:
		0:
			text_box.display_text(dialog_lines[current_line_index]["text"])
		1:
			text_box.display_text(dialog_lines[0])
		2:
			text_box.display_text(dialog_lines[current_line_index]["text"])
	
	can_advance_line = false
	
func _on_text_box_finished_displaying():
	can_advance_line = true
	await get_tree().create_timer(1.0).timeout
	text_box.queue_free()
	
	current_line_index += 1		
	if current_line_index >= dialog_lines.size():
		is_dialog_active = false
		current_line_index = 0
		return
	
	_show_text_box()
	
	
	
	
	
