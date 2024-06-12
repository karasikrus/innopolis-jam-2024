extends Button
class_name TileButton

@export var tile_to_spawn : PackedScene

var spawned_tile : DraggableTile

const SPAWNED_TILES_GROUP_NAME = "spawned_tiles"

func spawn_draggable_tile():
	spawned_tile = tile_to_spawn.instantiate() as DraggableTile
	get_tree().get_first_node_in_group(SPAWNED_TILES_GROUP_NAME).add_child(spawned_tile)
	spawned_tile.global_position = get_global_mouse_position()
