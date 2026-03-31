extends Area2D

@onready var canvas = get_tree().get_first_node_in_group("canvas_modulate")
@onready var light  = get_tree().get_first_node_in_group("player_light")

func _ready():
	body_entered.connect(_on_entre)
	body_exited.connect(_on_sort)

func _on_entre(body):
	if body is CharacterBody2D:
		body.dans_zone_sombre = true
		body.lampe_activee = false
		# D'abord assombrit l'écran
		var tween = create_tween()
		tween.tween_property(canvas, "color", Color(0, 0, 0), 1.5)
		# Puis allume la lumière une fois l'écran sombre
		tween.tween_callback(func(): light.enabled = true)

func _on_sort(body):
	if body is CharacterBody2D:
		body.dans_zone_sombre = false
		body.lampe_activee = false
		light.enabled = false
		var tween = create_tween()
		tween.tween_property(canvas, "color", Color(1, 1, 1), 1.5)
