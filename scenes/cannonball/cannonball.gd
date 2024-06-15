extends Area2D
class_name CannonBall


enum DIRECTION {UP, RIGHT, DOWN, LEFT, NONE}
var direction_vectors = [Vector2(0, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0), Vector2(0, 0)]
@export var velocity = 50
@export var flight_direction = DIRECTION.UP
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func area_intersection(body: Node2D):
	if body is Player:
		intersection_with_player(body as Player)
	elif body is MirroringStone:
		intersection_with_mirroring_stone(body)
	else:
		intersection_with_static_object()

	pass
	
func intersection_with_static_object():
	queue_free()
	
func intersection_with_player(player):
	player.kill_player()
	
func intersection_with_mirroring_stone(stone):
	pass #(dsmoliakov): map direction with stone
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var delta_pos = direction_vectors[flight_direction] * velocity * delta
	position += delta_pos
	pass
