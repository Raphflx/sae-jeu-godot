extends CharacterBody2D

@export var SPEED = 400.0
@export var JUMP_VELOCITY = -500.0
@export var DASH_SPEED = 900.0
@export var GRAVITE_MULT : float = 1.5

var peut_dasher = true
var en_dash = false
var vitesse_dash = 0.0
var direction_dash = Vector2.ZERO
var etat_air = false
var Mort = false

func _physics_process(delta: float) -> void:

	# ── Récupère le dash quand on touche le sol ────────────
	if is_on_floor():
		peut_dasher = true
		etat_air = false
	else:
		etat_air = true

	# ── Gravité ────────────────────────────────────────────
	if not is_on_floor():
		velocity += get_gravity() * GRAVITE_MULT * delta

	# ── Saut ───────────────────────────────────────────────
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# ── Déplacement normal (désactivé pendant le dash) ─────
	var direction := Input.get_axis("ui_left", "ui_right")
	if not en_dash:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# ── Déclenchement du dash ──────────────────────────────
	var dir = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up",   "ui_down")
	)

	if Input.is_action_just_pressed("dash") and peut_dasher:

		direction_dash = dir.normalized()
		peut_dasher = false
		en_dash = true
		jouer_animation_dash(direction_dash)
		vitesse_dash = DASH_SPEED

		var tween = create_tween()
		tween.tween_property(self, "vitesse_dash", 0.5, 0.3)
		tween.tween_callback(func(): en_dash = false)

	# ── Applique vélocité dash ─────────────────────────────
	if en_dash:
		velocity.x = direction_dash.x * vitesse_dash
		if abs(direction_dash.y) > 0.3:
			velocity.y = direction_dash.y * vitesse_dash

	move_and_slide()

	# ── Détection des tiles mortelles ─────────────────────
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is TileMap:
			var tile_pos = collider.local_to_map(collision.get_position())
			var tile_data = collider.get_cell_tile_data(0, tile_pos)
			if tile_data and tile_data.get_custom_data("mortel"):
				mourir()

	
	# ── Animations ─────────────────────────────────────────
	if en_dash:
		pass
	elif not is_on_floor():
		jouer_animation("Saut")
	elif direction:
		jouer_animation("Marche")
	else:
		jouer_animation("Idle")

func jouer_animation(nom: String):
	if $AnimatedSprite2D.animation != nom and Mort == false:
		$AnimatedSprite2D.play(nom)
		
func jouer_animation_dash(dir: Vector2):
	if   dir.x > 0.5  and abs(dir.y) < 0.4:   jouer_animation("Dash_droite")
	elif dir.x < -0.5 and abs(dir.y) < 0.4:   jouer_animation("Dash_gauche")
	elif dir.y < -0.5 and abs(dir.x) < 0.4:   jouer_animation("Dash_haut")
	elif dir.y > 0.5  and abs(dir.x) < 0.4:   jouer_animation("Dash_bas")
	elif dir.x > 0.3  and dir.y < -0.3:        jouer_animation("Dash_haut_droite")
	elif dir.x < -0.3 and dir.y < -0.3:        jouer_animation("Dash_haut_gauche")
	elif dir.x > 0.3  and dir.y > 0.3:         jouer_animation("Dash_bas_droite")
	elif dir.x < -0.3 and dir.y > 0.3:         jouer_animation("Dash_bas_gauche")

func mourir():
	Mort = true
	velocity = Vector2.ZERO
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("Mort")
	set_physics_process(false)
	
	await get_tree().create_timer(0.7).timeout  # attend 1 seconde
	
	global_position = $"../Spawn".global_position
	set_physics_process(true)
	Mort = false
