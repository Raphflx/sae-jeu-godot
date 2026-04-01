extends Control

@onready var son_survol = $Boutons/SonSuvol
@onready var label_blink = $EntrerClignotte  #label APPUIE SUR ENTRÉE
@onready var curseur = $Curseur  
# liste des boutons du menu dans l'ordre
@onready var boutons = [$Boutons/NouvellePartie, $Boutons/Options, $Boutons/Quitter]
var index = 0  # position actuelle du curseur (0 = premier bouton)

# Called when the node enters the scene tree for the first time.

func _ready():
	for btn in boutons:
    	btn.focus_mode = Control.FOCUS_NONE
	grab_focus()
	_mettre_a_jour_curseur()
	
func nouvelle_partie_appuye():
    get_tree().change_scene_to_file("res://Scenes/selection_niveau.tscn")

func options_appuye():
    get_tree().change_scene_to_file("res://Scenes/menu_options.tscn")

func quitter_appuye():
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event):
	# Descend avec flèche bas
	if event.is_action_pressed("ui_down"):
		index = (index + 1) % boutons.size()  # revient au début si on dépasse le dernier
		_mettre_a_jour_curseur()
		son_survol.play()
	# Monte avec flèche haut
	if event.is_action_pressed("ui_up"):
		index = (index - 1 + boutons.size()) % boutons.size()  # revient à la fin si on dépasse le premier
		_mettre_a_jour_curseur()
		son_survol.play()
	# Confirme avec entrée
	if event.is_action_pressed("ui_accept"):
		boutons[index].emit_signal("pressed")
		son_survol.play()

func _mettre_a_jour_curseur():
	# Hover jaune
	for i in boutons.size():
		if i == index:
        	boutons[i].add_theme_color_override("font_color", Color("#f5c518"))
		else:
        	boutons[i].add_theme_color_override("font_color", Color("#e8e8f0"))
	# Récupère le bouton actuellement sélectionné
	var btn = boutons[index]
	# Positionne le curseur à gauche du bouton, centré verticalement
	curseur.global_position = Vector2(
		btn.global_position.x - 30,       
		btn.global_position.y + btn.size.y / 2 - curseur.size.y / 2  # centré en hauteur
	)

func survol_nouvelle_partie():
    son_survol.play()

func survol_options():
    son_survol.play()
	
func survol_quitter():
    son_survol.play()
