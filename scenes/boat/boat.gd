extends Node2D

@export var starting_tile : WaterTile = null 
@export var end_tile : WaterTile = null
@export var max_distance_to_next_cell = 80 #hacky way to check that we are still in an achievable distance
@onready var timer = $FromTileToTileTimer
var current_tile = null
var prev_tile = null

# Called when the node enters the scene tree for the first time.
func _ready():
	current_tile = starting_tile
	prev_tile = starting_tile
	find_next_tile_to_move_in()
	timer.start()
	timer.connect("timeout", find_next_tile_to_move_in)
	pass # Replace with function body.

func find_next_tile_to_move_in():
	var tiles = get_tree().get_nodes_in_group("water_tiles")
	var end_tile_name = end_tile.name
	var starting_tile_name = starting_tile.name
	var min_distance = 10000000
	var next_tile = null
	for tile in tiles:
		if current_tile == end_tile:
			break
		var distance_to_current_tile = (tile.global_position - current_tile.global_position).length()
		if current_tile == tile or distance_to_current_tile > max_distance_to_next_cell:
			continue
		var distance_to_end = (tile.global_position - end_tile.global_position).length()
		if distance_to_end < min_distance:
			min_distance = distance_to_end
			next_tile = tile
	if next_tile == null:
		swap_direction()
		return
	prev_tile = current_tile
	current_tile = next_tile
	
func swap_direction():
	var temp = end_tile
	end_tile = starting_tile
	starting_tile = temp
	current_tile = starting_tile
	prev_tile = starting_tile
	find_next_tile_to_move_in() 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var normalized_time = 1 - timer.time_left / timer.wait_time
	global_position = lerp(prev_tile.global_position, current_tile.global_position, normalized_time)
	
	pass
