extends StaticBody2D
class_name Tile

func _ready():
	GlobalEvents.tiles_removed.connect(remove)


func remove():
	queue_free()


func placement():
	pass
