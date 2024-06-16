extends Area2D
class_name DraggableTile

signal placed(successfully : bool)

const SPAWNED_TILES_GROUP_NAME = "spawned_tiles"

@export var tile_to_spawn : PackedScene

var empty_space : EmptySpace

func _ready():
	GlobalEvents.emit_tile_is_dragged(true)

func _process(delta):
	global_position = get_global_mouse_position()
	if Input.is_action_just_released("click"):
		on_mouse_released()


func on_mouse_released():
	if empty_space != null:
		empty_space.deactivate()
		var tile = tile_to_spawn.instantiate() as Tile
		get_tree().get_first_node_in_group(SPAWNED_TILES_GROUP_NAME).add_child(tile)
		tile.global_position = empty_space.global_position
		tile.placement()
		placed.emit(true)
	else:
		placed.emit(false)
	GlobalEvents.emit_tile_is_dragged(false)
	queue_free()


func _on_area_entered(area):
	if area.owner is EmptySpace:
		empty_space = area.owner


func _on_area_exited(area):
	if area.owner == empty_space:
		empty_space = null
