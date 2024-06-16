extends StaticBody2D
class_name Npc

@export var dialog : DialogicTimeline
@export var unloked_block_index : int = 0

var next_dialog : DialogicTimeline
var player : Player


func _ready():
	next_dialog = dialog

func kick(talking_player : Player):
	if !next_dialog:
		return
	
	Dialogic.start(next_dialog)
	next_dialog = null
	player = talking_player
	player.is_talking = true
	Dialogic.timeline_ended.connect(end_dialog)

func end_dialog():
	Dialogic.timeline_ended.disconnect(end_dialog)
	if unloked_block_index > 0:
		player.get_new_block(unloked_block_index)
		return
	player.is_talking = false
