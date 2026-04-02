extends Control

@onready var slider_musique = $Conteneur/VolumeMusique/SonMusique
@onready var slider_effets = $Conteneur/VolumeEffets/SonEffets
@onready var bouton_retour = $Conteneur/BoutonRetour  # ← adapte ce chemin

func _ready():
	slider_musique.min_value = 0
	slider_musique.max_value = 100
	slider_musique.value = 100
	slider_effets.min_value = 0
	slider_effets.max_value = 100
	slider_effets.value = 100
	
	bouton_retour.pressed.connect(bouton_retour_pressed)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		bouton_retour_pressed()

func bouton_retour_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu_principal.tscn")

func son_musique_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		linear_to_db(value / 100.0)
	)

func son_effets_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(value / 100.0)
	)
