extends Node

signal tiles_removed

signal new_tile_unlocked(index : int)


func remove_tiles():
	tiles_removed.emit()


func unlock_new_tile(index : int):
	new_tile_unlocked.emit(index)
