extends CanvasLayer

var boutons = []
var index = 0

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	boutons = [
		$Bouttons/Reprendre,
		$Bouttons/Recommencer,
		$Bouttons/MenuPrincipal
	]
	for btn in boutons:
		btn.focus_mode = Control.FOCUS_NONE
	print(boutons)

func ouvrir():
	show()
	get_tree().paused = true
	index = 0
	_mettre_a_jour_selection()

func fermer():
	hide()
	get_tree().paused = false

func _input(event):
	if not visible:
		return
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause"):
		fermer()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("ui_down"):
		index = (index + 1) % boutons.size()
		_mettre_a_jour_selection()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("ui_up"):
		index = (index - 1 + boutons.size()) % boutons.size()
		_mettre_a_jour_selection()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("ui_accept"):
		boutons[index].emit_signal("pressed")
		get_viewport().set_input_as_handled()

func _mettre_a_jour_selection():
	for i in boutons.size():
		if i == index:
			if i == 2:
				boutons[i].add_theme_color_override("font_color", Color("#e84040"))
			else:
				boutons[i].add_theme_color_override("font_color", Color("#f5c518"))
		else:
			boutons[i].add_theme_color_override("font_color", Color("#e8e8f0"))

func reprendre_appuye() -> void:
	fermer()

func recommencer_appuye() -> void:
	get_tree().paused = false
	await get_tree().process_frame
	get_tree().reload_current_scene()

func menu_principal_appuye() -> void:
	get_tree().paused = false
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://Scenes/menu_principal.tscn")
