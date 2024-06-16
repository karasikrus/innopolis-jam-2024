extends StaticBody2D
class_name EmptySpace

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var area_2d = $Area2D
@onready var animation_player = $AnimationPlayer



func _ready():
	GlobalEvents.tiles_removed.connect(activate)
	GlobalEvents.tile_is_dragged.connect(update_highlight)

func deactivate():
	sprite_2d.visible = false
	collision_shape_2d.disabled = true
	area_2d.monitoring = false
	area_2d.monitorable = false


func activate():
	sprite_2d.visible = true
	collision_shape_2d.disabled = false
	area_2d.monitoring = true
	area_2d.monitorable = true

func update_highlight(on : bool):
	if on:
		animation_player.play("highlight")
	else:
		animation_player.play("default")
