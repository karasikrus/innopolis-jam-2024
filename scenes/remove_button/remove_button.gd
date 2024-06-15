extends Button
class_name RemoveButton

@onready var audio_stream_player = $AudioStreamPlayer



func remove_tiles():
	GlobalEvents.remove_tiles()
	audio_stream_player.play()
