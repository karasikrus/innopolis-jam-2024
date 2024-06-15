extends StaticBody2D
class_name Npc

@export var dialog : DialogicTimeline

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
	player.is_talking = false
