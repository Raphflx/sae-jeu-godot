extends CanvasLayer

func _ready():
	hide()

func ouvrir():
	show()
	get_tree().paused = true

func fermer():
	hide()
	get_tree().paused = false

func reprendre_appuye():
	fermer()

func recommencer_appuye():
	get_tree().paused = false
	get_tree().reload_current_scene()

func menu_principal_appuye():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/menu_principal.tscn")
