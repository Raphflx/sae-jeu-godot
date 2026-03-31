extends Area2D

@onready var canvas = get_tree().get_first_node_in_group("canvas_modulate")
@onready var light  = get_tree().get_first_node_in_group("player_light")

@export var vitesse = 1.5

func _ready():
	body_entered.connect(_on_entre)
	body_exited.connect(_on_sort)
	# Lumière invisible au départ
	if light:
		light.energy = 0

func _on_entre(body):
	if body is CharacterBody2D:
		var tween = create_tween()
		# Assombrit l'écran
		tween.tween_property(canvas, "color", Color(0.05, 0.05, 0.08), vitesse)
		# Allume la lumière du joueur
		tween.parallel().tween_property(light, "energy", 1.5, vitesse)

func _on_sort(body):
	if body is CharacterBody2D:
		var tween = create_tween()
		# Rallume l'écran
		tween.tween_property(canvas, "color", Color(1, 1, 1), vitesse)
		# Éteint la lumière du joueur
		tween.parallel().tween_property(light, "energy", 0.0, vitesse)
