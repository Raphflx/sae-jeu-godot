extends Control

@onready var boutons = [$Conteneur/ConteneurNiveau/ContLvl1/BtnLvl1, $Conteneur/ConteneurNiveau/ContLvl2/BtnLvl2]  
@onready var son_survol = $SonSurvol
var index = 0

func _ready():
	for btn in boutons:
		btn.focus_mode = Control.FOCUS_NONE
	_mettre_a_jour_selection()
	grab_focus()

func _input(event):
	# Gauche / droite pour naviguer
	if event.is_action_pressed("ui_left"):
		index = (index - 1 + boutons.size()) % boutons.size()
		son_survol.play()
		_mettre_a_jour_selection()
	if event.is_action_pressed("ui_right"):
		index = (index + 1) % boutons.size()
		son_survol.play()
		_mettre_a_jour_selection()
	# Entrée pour confirmer
	if event.is_action_pressed("ui_accept"):
		boutons[index].emit_signal("pressed")

func _mettre_a_jour_selection():
	# Jaune sur le niveau sélectionné, blanc sur les autres
	for i in boutons.size():
		if i == index:
			boutons[i].add_theme_color_override("font_color", Color("#f5c518"))
		else:
			boutons[i].add_theme_color_override("font_color", Color("#e8e8f0"))

func btn_lvl1_pressed():
	get_tree().change_scene_to_file("res://Scenes/niveau_1.tscn")

func btn_lv2_pressed():
	get_tree().change_scene_to_file("res://Scenes/niveau_2.tscn")


func btn_lvl_2_pressed() -> void:
	pass # Replace with function body.
