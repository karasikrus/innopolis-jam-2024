extends Tile
class_name GrassTile

@onready var audio_stream_player_2d = $AudioStreamPlayer2D


func placement():
	audio_stream_player_2d.play()
