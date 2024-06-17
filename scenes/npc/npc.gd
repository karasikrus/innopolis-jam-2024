extends StaticBody2D
class_name Npc

@export var dialog : DialogicTimeline
@export var dialog_2 :DialogicTimeline
@export var unloked_block_index : int = 0
@export var new_block_dialog_number : int = 2

var next_dialog : DialogicTimeline
var player : Player
var dialog_number : int = 0


func _ready():
	next_dialog = dialog

func kick(talking_player : Player):
	if !next_dialog:
		return
	dialog_number += 1
	Dialogic.start(next_dialog)
	if dialog_number == 1:
		next_dialog = dialog_2
	else:
		next_dialog = null
	player = talking_player
	player.is_talking = true
	Dialogic.timeline_ended.connect(end_dialog)

func end_dialog():
	Dialogic.timeline_ended.disconnect(end_dialog)
	if unloked_block_index > 0 and dialog_number == new_block_dialog_number:
		player.get_new_block(unloked_block_index)
		return
	player.stop_talking()
