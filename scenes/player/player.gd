extends CharacterBody2D
class_name Player

@onready var animation_player = $AnimationPlayer

@onready var ray_cast_2d = $fall_checks/RayCast2D
@onready var ray_cast_2d_2 = $fall_checks/RayCast2D2
@onready var ray_cast_2d_3 = $fall_checks/RayCast2D3
@onready var ray_cast_2d_4 = $fall_checks/RayCast2D4

@onready var sprite_2d = $Sprite2D
@onready var stop_talking_timer = $StopTalkingTimer


var speed = 100  # speed in pixels/sec
var direction : Vector2 = Vector2.ZERO
var face_direction : Vector2 = Vector2.ZERO
var is_kicking := false
var is_talking := false
var is_falling := false
var is_dead := false
var is_respawning := false

var frog : Frog
var current_npc : Npc

var respawn_point : Vector2 = Vector2.ZERO

func _process(delta):
	animate()


func _physics_process(delta):
	if is_respawning:
		is_respawning = false
		is_falling = false
		global_position = respawn_point
		animation_player.play("respawn")
		return
	
	if is_talking or is_falling or is_dead:
		return
	
	if  check_fall_ray_casts():
		animation_player.play("fall")
		is_dead = true
		is_falling = true
		return
	
	direction = Input.get_vector("left", "right", "up", "down")
	face_direction = get_face_direction(direction)
	velocity = direction * speed
	
	if Input.is_action_just_pressed("kick"):
		kick()
	
	
	move_and_slide()
	

func kick():
	if is_kicking:
		return
	is_kicking = true
	animate_kick()
	animation_player.animation_finished.connect(stop_kicking)
	if frog:
		frog.kick(face_direction)
	if current_npc:
		current_npc.kick(self)


func stop_kicking(anim_name: StringName):
	if not anim_name in ["kick_down", "kick_up", "kick_left", "kick_right"]:
		return
	animation_player.animation_finished.disconnect(stop_kicking)
	is_kicking = false

func get_face_direction(dir : Vector2) -> Vector2:
	if dir.length() < 0.001:
		# no input: same face direction
		return face_direction
		
	if abs(dir.x) >= abs(dir.y):
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
	

func animate():
	if is_kicking or is_falling or is_dead or is_respawning or is_talking:
		return
	if direction.length() > 0.001 and velocity.length() > 0.001:
		animate_walk()
	else:
		animate_idle()


func animate_walk():
	if face_direction == Vector2.UP:
		animation_player.play("walk_up")
	elif face_direction == Vector2.LEFT:
		animation_player.play('walk_left')
	elif face_direction == Vector2.DOWN:
		animation_player.play('walk_down')
	elif face_direction == Vector2.RIGHT:
		animation_player.play('walk_right')


func animate_idle():
	if face_direction == Vector2.UP:
		animation_player.play("idle_up")
	elif face_direction == Vector2.LEFT:
		animation_player.play('idle_left')
	elif face_direction == Vector2.DOWN:
		animation_player.play('idle_down')
	elif face_direction == Vector2.RIGHT:
		animation_player.play('idle_right')


func animate_kick():
	if face_direction == Vector2.UP:
		animation_player.play("kick_up")
	elif face_direction == Vector2.LEFT:
		animation_player.play('kick_left')
	elif face_direction == Vector2.DOWN:
		animation_player.play('kick_down')
	elif face_direction == Vector2.RIGHT:
		animation_player.play('kick_right')


func _on_kick_area_2d_body_entered(body):
	if body is Frog:
		frog = body as Frog
	elif body is Npc:
		current_npc = body as Npc
	


func _on_kick_area_2d_body_exited(body):
	if body is Frog:
		frog = null
	elif body is Npc:
		current_npc = null


func check_fall_ray_casts() -> bool:
	print(ray_cast_2d.is_colliding())
	return ray_cast_2d.is_colliding() and ray_cast_2d_2.is_colliding() and ray_cast_2d_3.is_colliding() and ray_cast_2d_4.is_colliding()


func kill_player():
	pass


func respawn():
	is_respawning = true
	global_position = respawn_point


func finish_respawn():
	is_dead = false
	is_falling = false
	is_kicking = false
	is_talking = false

func _on_checkpoint_area_2d_area_entered(area):
	var checkpoint = area as Checkpoint
	if checkpoint:
		respawn_point = (checkpoint.player_spawn as Node2D).global_position


func get_new_block(index: int):
	animation_player.play("new_block")
	animation_player.animation_finished.connect(finish_getting_new_block.bind(index))


func finish_getting_new_block(anim_name: StringName, index : int):
	if anim_name != "new_block":
		return
	animation_player.animation_finished.disconnect(finish_getting_new_block)
	GlobalEvents.unlock_new_tile(index)
	is_talking = false

func stop_talking():
	stop_talking_timer.start()
	await stop_talking_timer.timeout
	is_talking = false
