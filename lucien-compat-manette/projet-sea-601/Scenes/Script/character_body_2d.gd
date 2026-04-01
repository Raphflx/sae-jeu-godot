extends CharacterBody2D
# ── ÉNERGIE ─────────────────────────────────────────────
@export var energie_max : float = 100.0
@export var energie : float = 100.0
@export var perte_energie_par_seconde : float = 5.0
@export var recharge_par_seconde : float = 20.0

# ── MOUVEMENT ───────────────────────────────────────────
@export var SPEED = 400.0
@export var JUMP_VELOCITY = -500.0
@export var DASH_SPEED = 900.0
@export var GRAVITE_MULT : float = 1.5

# ── UI ──────────────────────────────────────────────────
@onready var barre_energie = $"CanvasLayer/ProgressBar"
@onready var menu_pause = $"../MenuPause"

# ── VARIABLES ───────────────────────────────────────────
var en_recharge = false
var peut_dasher = true
var en_dash = false
var vitesse_dash = 0.0
var direction_dash = Vector2.ZERO
var etat_air = false
var Mort = false
var derniere_direction = Vector2(1, 0)

# ── INITIALISATION ──────────────────────────────────────
func _ready():
	energie = energie_max

func _physics_process(delta: float) -> void:

	# ── UI ÉNERGIE ───────────────────────────────────────
	if barre_energie:
		barre_energie.value = energie
		barre_energie.max_value = energie_max
		if energie < 20:
			barre_energie.modulate = Color(1, 0.3, 0.3)
		else:
			barre_energie.modulate = Color(1, 1, 1)

	# ── Gestion énergie ──────────────────────────────────
	if not en_recharge:
		energie -= perte_energie_par_seconde * delta
	else:
		energie += recharge_par_seconde * delta

	energie = clamp(energie, 0, energie_max)

	if energie <= 0 and not Mort:
		mourir()

	# ── Récupère le dash quand on touche le sol ────────────
	if is_on_floor():
		peut_dasher = true
		etat_air = false
	else:
		etat_air = true

	# ── Gravité (suspendue pendant le dash) ────────────────
	if not is_on_floor() and not en_dash:
		velocity += get_gravity() * GRAVITE_MULT * delta

	# ── Saut ───────────────────────────────────────────────
	if Input.is_action_just_pressed("sauter") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# ── Lire la direction du joueur ────────────────────────
	var dir = Vector2(
		Input.get_axis("Gauche", "Droite"),
		Input.get_axis("Haut",   "Bas")
	)

	if dir.length() > 0.2:
		derniere_direction = dir.normalized()

	# ── Déplacement normal (désactivé pendant le dash) ─────
	var direction : float = dir.x
	if not en_dash:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# ── Déclenchement du dash ──────────────────────────────
	if Input.is_action_just_pressed("dash") and peut_dasher:
		var dash_dir : Vector2
		if dir.length() > 0.2:
			# Si l'axe vertical est dominant, on ignore le x pour éviter les drifts
			if abs(dir.y) > abs(dir.x) * 1.5:
				dash_dir = Vector2(0, sign(dir.y))
			# Si l'axe horizontal est dominant
			elif abs(dir.x) > abs(dir.y) * 1.5:
				dash_dir = Vector2(sign(dir.x), 0)
			# Sinon dash diagonal normalisé
			else:
				dash_dir = dir.normalized()
		else:
			dash_dir = derniere_direction

		direction_dash = dash_dir
		peut_dasher = false
		en_dash = true
		jouer_animation_dash(direction_dash)
		vitesse_dash = DASH_SPEED
		velocity.y = 0.0

		var tween = create_tween()
		tween.tween_property(self, "vitesse_dash", 0.0, 0.25)
		tween.tween_callback(func(): en_dash = false)

	# ── Applique vélocité dash ─────────────────────────────
	if en_dash:
		velocity.x = direction_dash.x * vitesse_dash
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

# ── ANIMATIONS ─────────────────────────────────────────

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

	await get_tree().create_timer(0.7).timeout
	var spawn = get_tree().get_first_node_in_group("spawn")
	if spawn:
		global_position = spawn.global_position
	set_physics_process(true)
	Mort = false

# ── RECHARGE ───────────────────────────────────────────
func commencer_recharge():
	en_recharge = true

func arreter_recharge():
	en_recharge = false

# ── MENU PAUSE ─────────────────────────────────────────
func _input(event):
	if event.is_action_pressed("pause"):
		if menu_pause.visible:
			menu_pause.fermer()
		else:
			menu_pause.ouvrir()
