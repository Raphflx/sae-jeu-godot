extends Control

@onready var label_blink = $EntrerClignotte  #label APPUIE SUR ENTRÉE

# Called when the node enters the scene tree for the first time.

func _ready():
	pass
func nouvelle_partie_appuye():
	get_tree().change_scene_to_file("res://Scene/monde.tscn")

func options_appuye():
	pass  # plus tard

func quitter_appuye():
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
