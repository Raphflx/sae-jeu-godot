extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

var test = 0



func _physics_process(delta: float) -> void:

	
	if not Input.is_anything_pressed() and is_on_floor():
		$AnimatedSprite2D.play("Marche")
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		$AnimatedSprite2D.play("Saut")
	else :
		$AnimatedSprite2D.stop()
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("Saut")
	else :
		$AnimatedSprite2D.stop()


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if is_on_floor():
		if direction:
			velocity.x = direction * SPEED
			test = 1
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$AnimatedSprite2D.stop()
	else :
		if direction:
			velocity.x = direction * SPEED
			$AnimatedSprite2D.play("Saut")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$AnimatedSprite2D.stop()
	move_and_slide()
	
func test_anim():
	if test == 1 and $AnimatedSprite2D.animation != ("Marche"):
		$AnimatedSprite2D.play("Marche") 
	
