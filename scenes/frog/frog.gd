extends CharacterBody2D
class_name Frog

@export var kick_acceleration : float = 200
@export var deceleration : float = 200

@onready var animation_player = $AnimationPlayer
@onready var jump_animation_player = $JumpAnimationPlayer

var ground_deceleration : float = 30
var velocity_length : float = 0
var direction : Vector2 = Vector2.ZERO
var face_direction : Vector2 = Vector2.ZERO


func _process(delta):
	update_animation_speed()


func _physics_process(delta):
	velocity_length = move_toward(velocity_length, 0, deceleration * delta)
	velocity = direction * velocity_length
	face_direction = get_face_direction(velocity)
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		direction = velocity.normalized()
		


func kick(kick_direction):
	direction = kick_direction
	velocity_length = kick_acceleration
	animation_player.stop()
	animation_player.play("kick")
	jump_animation_player.stop()
	jump_animation_player.play("jump")
	

func update_animation_speed():
	if animation_player.current_animation != "kick":
		animation_player.speed_scale = 1
		return
	
	var animation_speed = lerpf(0, 2, velocity_length/ kick_acceleration)
	animation_player.speed_scale = animation_speed


func get_face_direction(dir : Vector2) -> Vector2:
	if dir.length() < 0.001:
		# no input: same face direction
		return face_direction
		
	if abs(dir.x) > abs(dir.y):
		# horizontal
		if dir.x >= 0:
			return Vector2.RIGHT
		else:
			return Vector2.LEFT
	else:
		# vertical
		if dir.y >= 0:
			return Vector2.DOWN
		else:
			return Vector2.UP
