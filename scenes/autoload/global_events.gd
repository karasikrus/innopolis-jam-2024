extends Node

signal tiles_removed
signal tile_is_dragged(is_dragged: bool)

signal new_tile_unlocked(index : int)


func remove_tiles():
	tiles_removed.emit()


func unlock_new_tile(index : int):
	new_tile_unlocked.emit(index)

func emit_tile_is_dragged(is_dragged : bool):
	tile_is_dragged.emit(is_dragged)
