extends CharacterBody2D

var speed = 100  # speed in pixels/sec
var direction : Vector2 = Vector2.ZERO
var face_direction : Vector2 = Vector2.ZERO

var frog : Frog

func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	face_direction = get_face_direction(direction)
	velocity = direction * speed
	
	if Input.is_action_just_pressed("kick"):
		kick()
	
	
	move_and_slide()
	

func kick():
	if frog == null:
		return
	frog.kick(face_direction)

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
	




func _on_kick_area_2d_body_entered(body):
	frog = body as Frog
	


func _on_kick_area_2d_body_exited(body):
	frog = null
