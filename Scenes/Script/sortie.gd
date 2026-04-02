extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
	GameManager._on_scene_changed()

func _on_body_entered(body):
	if body is CharacterBody2D:
		GameManager.niveau_suivant()
