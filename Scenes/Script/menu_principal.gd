extends Control

@onready var curseur = $Curseur
@onready var boutons = [$Boutons/ChoisirNiveau, $Boutons/Options, $Boutons/Quitter]
var index = 0
var son_survol: AudioStreamPlayer2D

func _ready():
	# Connexion des signaux seulement si pas déjà connectés
	if not boutons[0].pressed.is_connected(choisir_niveau_appuye):
		boutons[0].pressed.connect(choisir_niveau_appuye)
	if not boutons[1].pressed.is_connected(options_appuye):
		boutons[1].pressed.connect(options_appuye)
	if not boutons[2].pressed.is_connected(quitter_appuye):
		boutons[2].pressed.connect(quitter_appuye)
	
	# Récupère SonSurvol seulement s'il existe
	if has_node("SonSurvol"):
		son_survol = $SonSurvol
	
	for btn in boutons:
		btn.focus_mode = Control.FOCUS_NONE
	
	_mettre_a_jour_curseur()
	_mettre_a_jour_selection()

func options_appuye():
	get_tree().change_scene_to_file("res://Scenes/menu_options.tscn")

func quitter_appuye():
	get_tree().quit()

func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		index = (index - 1 + boutons.size()) % boutons.size()
		_jouer_son_survol()
		_mettre_a_jour_curseur()
		_mettre_a_jour_selection()
	elif event.is_action_pressed("ui_down"):
		index = (index + 1) % boutons.size()
		_jouer_son_survol()
		_mettre_a_jour_curseur()
		_mettre_a_jour_selection()
	elif event.is_action_pressed("ui_accept"):
		boutons[index].emit_signal("pressed")

func _jouer_son_survol():
	if son_survol != null:
		son_survol.play()

func _mettre_a_jour_selection():
	for i in boutons.size():
		if i == index:
			boutons[i].add_theme_color_override("font_color", Color("#f5c518"))
		else:
			boutons[i].add_theme_color_override("font_color", Color("#e8e8f0"))

func _mettre_a_jour_curseur():
	var btn = boutons[index]
	curseur.global_position = Vector2(
		btn.global_position.x - 30,
		btn.global_position.y + btn.size.y / 2 - curseur.size.y / 2
	)


func choisir_niveau_appuye():
	get_tree().change_scene_to_file("res://Scenes/selection_niveau.tscn")
	
