extends Tile
class_name MirroringStone


var empty_space : EmptySpace
enum DIRECTION {UP, RIGHT, DOWN, LEFT, NONE}

@export var stone_input = DIRECTION.UP
@export var stone_output = DIRECTION.RIGHT



func _process(delta):
	pass



func _on_area_entered(area):
	if area is CannonBall:
		if area.flight_direction == stone_input:
			area.flight_direction = stone_output

