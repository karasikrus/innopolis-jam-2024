extends CharacterBody2D
class_name Frog

@export var kick_acceleration : float = 200
@export var deceleration : float = 200

@onready var animation_player = $AnimationPlayer
@onready var jump_animation_player = $JumpAnimationPlayer
@onready var ray_cast_2d = $RayCast2D
@onready var sprite_2d = $Sprite2D

@onready var fall_audio_stream_player_2d = $AudioStreamPlayers/FallAudioStreamPlayer2D
@onready var kick_audio_stream_player_2d = $AudioStreamPlayers/KickAudioStreamPlayer2D
@onready var hit_audio_stream_player_2d = $AudioStreamPlayers/HitAudioStreamPlayer2D
@onready var quack_audio_stream_player_2d = $AudioStreamPlayers/QuackAudioStreamPlayer2D
@onready var respawn_audio_stream_player_2d = $AudioStreamPlayers/RespawnAudioStreamPlayer2D

@onready var frog_quack_timer = $FrogQuackTimer


var ground_deceleration : float = 30
var velocity_length : float = 0
var direction : Vector2 = Vector2.ZERO
var face_direction : Vector2 = Vector2.ZERO
var is_in_air := false
var is_falling := false
var is_respawning := false
var respawn_point : Vector2 = Vector2.ZERO

var tween : Tween


func _process(delta):
	update_animation_speed()


func _physics_process(delta):
	if is_respawning:
		return
	if !is_in_air and !is_falling:
		check_ground()
	velocity_length = move_toward(velocity_length, 0, deceleration * delta)
	velocity = direction * velocity_length
	face_direction = get_face_direction(velocity)
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		direction = velocity.normalized()
		play_hit_sound()
		


func kick(kick_direction):
	if is_respawning or is_falling or is_in_air:
		return
	direction = kick_direction
	velocity_length = kick_acceleration
	animation_player.stop()
	animation_player.play("kick")
	animation_player.seek(0.6, true)
	kick_audio_stream_player_2d.play()
	is_in_air = true
	tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, "scale", Vector2(1.5, 1.5), 0.2)
	tween.tween_property(sprite_2d, "scale", Vector2(1, 1), 0.3)
	tween.tween_callback(check_ground)
	tween.tween_callback(play_hit_sound)
	tween.tween_property(sprite_2d, "scale", Vector2(1.2, 1.2), 0.2)
	tween.tween_property(sprite_2d, "scale", Vector2(1, 1), 0.2)
	tween.tween_callback(play_hit_sound)
	tween.tween_callback(land)
	
func play_hit_sound():
	hit_audio_stream_player_2d.play()

func update_animation_speed():
	if animation_player.current_animation != "kick":
		animation_player.speed_scale = 1
		return
	if velocity_length < 1:
		animation_player.play("idle")
	
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

func check_ground():
	if ray_cast_2d.is_colliding():
		fall()

func fall():
	is_falling = true
	if tween:
		tween.kill()
	
	fall_audio_stream_player_2d.play()
	tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, "scale", Vector2(0.01, 0.01), 0.4)
	tween.tween_property(sprite_2d, "scale", Vector2(0.01, 0.01), 0.4)
	tween.tween_callback(respawn)

func land():
	is_in_air = false

func respawn():
	is_respawning = true
	is_in_air = false
	is_falling = false
	global_position = respawn_point
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, "scale", Vector2(1, 1), 0.4)
	tween.tween_callback(play_respawn_sound)
	tween.tween_callback(finish_respawn)


func play_respawn_sound():
	respawn_audio_stream_player_2d.play()


func finish_respawn():
	is_respawning = false
	

func quack():
	quack_audio_stream_player_2d.play()
	frog_quack_timer.start()


func _on_checkpoint_area_2d_area_entered(area):
	var checkpoint = area as Checkpoint
	if checkpoint:
		respawn_point = (checkpoint.frog_spawn as Node2D).global_position


func _on_quack_area_2d_body_entered(body):
	frog_quack_timer.stop()


func _on_quack_area_2d_body_exited(body):
	frog_quack_timer.start()
