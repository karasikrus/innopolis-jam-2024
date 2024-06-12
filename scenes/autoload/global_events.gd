extends Node

signal tiles_removed

func remove_tiles():
	tiles_removed.emit()
