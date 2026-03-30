extends Control

@onready var label_blink = $EntrerClignotte  #label APPUIE SUR ENTRÉE
@onready var curseur = $Curseur  
# liste des boutons du menu dans l'ordre
@onready var boutons = [$Boutons/NouvellePartie, $Boutons/Options, $Boutons/Quitter]
var index = 0  # position actuelle du curseur (0 = premier bouton)
@onready var son_survol = $SonSurvol  # le lecteur audio
# Called when the node enters the scene tree for the first time.

func _ready():
	for btn in boutons:
		btn.focus_mode = Control.FOCUS_NONE
	_mettre_a_jour_curseur()
	grab_focus()

func nouvelle_partie_appuye():
	get_tree().change_scene_to_file("res://Scene/monde.tscn")

func options_appuye():
	pass  # plus tard

func quitter_appuye():
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event):
	# Descend avec flèche bas
	if event.is_action_pressed("ui_down"):
		index = (index + 1) % boutons.size()  # revient au début si on dépasse le dernier
		son_survol.play()
		_mettre_a_jour_curseur()
	# Monte avec flèche haut
	if event.is_action_pressed("ui_up"):
		index = (index - 1 + boutons.size()) % boutons.size()  # revient à la fin si on dépasse le premier
		son_survol.play()
		_mettre_a_jour_curseur()
	# Confirme avec entrée
	if event.is_action_pressed("ui_accept"):
		boutons[index].emit_signal("pressed")

func _mettre_a_jour_curseur():
	# Récupère le bouton actuellement sélectionné
	var btn = boutons[index]
	# Positionne le curseur à gauche du bouton, centré verticalement
	curseur.global_position = Vector2(
		btn.global_position.x - 30,       
		btn.global_position.y + btn.size.y / 2 - curseur.size.y / 2  # centré en hauteur
	)
	# Change la couleur des boutons - jaune si sélectionné, blanc sinon
	for i in boutons.size():
		if i == index:
			boutons[i].add_theme_color_override("font_color", Color("#f5c518"))  # jaune
		else:
			boutons[i].add_theme_color_override("font_color", Color("#e8e8f0"))  # blanc normal



func survol_nouvelle_partie() -> void:
	son_survol.play()


func survol_options() -> void:
	son_survol.play()


func survol_quitter() -> void:
	son_survol.play()
