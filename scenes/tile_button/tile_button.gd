extends Button
class_name TileButton

@export var tile_to_spawn : PackedScene

@onready var audio_stream_player = $AudioStreamPlayer

var spawned_tile
var is_tile_placed := false

@export var final_tile_to_spawn : PackedScene

const SPAWNED_TILES_GROUP_NAME = "spawned_tiles"

func _ready():
	GlobalEvents.tiles_removed.connect(on_tiles_removed)


func spawn_draggable_tile():
	spawned_tile = tile_to_spawn.instantiate()
	get_tree().get_first_node_in_group(SPAWNED_TILES_GROUP_NAME).add_child(spawned_tile)
	spawned_tile.global_position = get_global_mouse_position()
	spawned_tile.placed.connect(on_tile_placed)
	spawned_tile.tile_to_spawn = final_tile_to_spawn
	visible = false
	disabled = true
	audio_stream_player.play()


func on_tile_placed(successfully : bool):
	if successfully:
		is_tile_placed = true
		visible = false
		disabled = true
	else:
		visible = true
		disabled = false


func on_tiles_removed():
	if spawned_tile != null:
		spawned_tile.queue_free()
		spawned_tile = null
	is_tile_placed = false
	visible = true
	disabled = false

