extends Control

@onready var boutons = [
	$Conteneur/ConteneurNiveau/ContLvl1/BtnLvl1,
	$Conteneur/ConteneurNiveau/ContLvl2/BtnLvl2,
	$Conteneur/ConteneurNiveau/ContLvl3/BtnLvl3,
	$Conteneur/ConteneurNiveau/ContLvl4/BtnLvl4,
	$Conteneur/ConteneurNiveau/ContLvl5/BtnLvl5
]
@onready var son_survol = $SonSurvol

var index = 0

func _ready():
	for btn in boutons:
		btn.focus_mode = Control.FOCUS_NONE
	_mettre_a_jour_selection()
	grab_focus()

func _input(event):
	if event.is_action_pressed("ui_left"):
		index = (index - 1 + boutons.size()) % boutons.size()
		son_survol.play()
		_mettre_a_jour_selection()
	if event.is_action_pressed("ui_right"):
		index = (index + 1) % boutons.size()
		son_survol.play()
		_mettre_a_jour_selection()
	if event.is_action_pressed("ui_accept"):
		boutons[index].emit_signal("pressed")

func _mettre_a_jour_selection():
	for i in boutons.size():
		if i == index:
			boutons[i].add_theme_color_override("font_color", Color("#f5c518"))
		else:
			boutons[i].add_theme_color_override("font_color", Color("#e8e8f0"))

func btn_lvl1_pressed():
	get_tree().change_scene_to_file("res://Scenes/niveau_1.tscn")

func btn_lvl_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/niveau_2.tscn")

func btn_lvl3_pressed():
	get_tree().change_scene_to_file("res://Scenes/niveau_3.tscn")

func btn_lvl4_pressed():
	get_tree().change_scene_to_file("res://Scenes/niveau_4.tscn")

func btn_lvl5_pressed():
	get_tree().change_scene_to_file("res://Scenes/niveau_5.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/menu_principal.tscn")
