extends CharacterBody2D
class_name Player

@onready var animation_player = $AnimationPlayer


var speed = 100  # speed in pixels/sec
var direction : Vector2 = Vector2.ZERO
var face_direction : Vector2 = Vector2.ZERO
var is_kicking := false

var frog : Frog


func _process(delta):
	animate()


func _physics_process(delta):
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
	animation_player.play("kick_down")
	animation_player.animation_finished.connect(stop_kicking)
	if frog == null:
		return
	frog.kick(face_direction)
	

func stop_kicking(anim_name: StringName):
	if anim_name != "kick_down":
		return
	animation_player.animation_finished.disconnect(stop_kicking)
	is_kicking = false

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
	

func animate():
	if is_kicking:
		return
	if direction.length() > 0.001 and velocity.length() > 0.001:
		animation_player.play("walk_down")
	else:
		animation_player.play("idle_down")



func _on_kick_area_2d_body_entered(body):
	frog = body as Frog
	


func _on_kick_area_2d_body_exited(body):
	frog = null
