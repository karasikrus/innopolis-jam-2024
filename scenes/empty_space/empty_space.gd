extends StaticBody2D
class_name EmptySpace

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var area_2d = $Area2D


func _ready():
	GlobalEvents.tiles_removed.connect(activate)

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
