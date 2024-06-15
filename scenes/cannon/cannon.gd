extends Area2D
class_name CannonCell

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var area_2d = $Area2D
@onready var fire_timer = $FireTimer
@onready var cannon_ball = preload("res://scenes/cannonball/cannonball.tscn")
@onready var spawn_point = $SpawnPoint
enum DIRECTION {UP, RIGHT, DOWN, LEFT, NONE}
#0 - up, 1 - right, 2 - down, 3 - left
@export var cannon_rotation = DIRECTION.UP 

func _ready():
	GlobalEvents.tiles_removed.connect(activate)
	fire_timer.connect("timeout", fire)
	fire_timer.start()
	update_rotation()

func update_rotation():
	if cannon_rotation == DIRECTION.UP:
		set_rotation_degrees(0)
	elif cannon_rotation == DIRECTION.RIGHT:
		set_rotation_degrees(90)
	elif cannon_rotation == DIRECTION.DOWN:
		set_rotation_degrees(180)
	elif cannon_rotation == DIRECTION.LEFT:
		set_rotation_degrees(270)
	else:
		set_rotation_degrees(0)

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

func fire():
	var cannon_ball_instance = cannon_ball.instantiate()
	cannon_ball_instance.flight_direction = cannon_rotation
	cannon_ball_instance.global_position = spawn_point.global_position
	get_parent().add_child(cannon_ball_instance)
	
	
	
