extends Node

var niveau_max     = 5
var _en_transition := false

const NIVEAUX = [
	"res://Scenes/niveau_1.tscn",
	"res://Scenes/niveau_2.tscn",
	"res://Scenes/niveau_3.tscn",
	"res://Scenes/niveau_4.tscn",
	"res://Scenes/niveau_5.tscn",
]

func get_niveau_actuel() -> int:
	# Lit le niveau depuis le nom de la scène en cours ex: "niveau_2"
	var scene_name = get_tree().current_scene.scene_file_path
	# Extrait le chiffre depuis "res://scenes/niveau_3.tscn"
	var regex = RegEx.new()
	regex.compile("niveau_(\\d+)")
	var result = regex.search(scene_name)
	if result:
		return result.get_string(1).to_int()
	return 1

func niveau_suivant():
	if _en_transition:
		return
	_en_transition = true

	var actuel = get_niveau_actuel()
	if actuel >= niveau_max:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/menu_principal.tscn")
	else:
		get_tree().call_deferred("change_scene_to_file",
			"res://Scenes/niveau_%d.tscn" % (actuel + 1))

func recommencer_niveau():
	if _en_transition:
		return
	_en_transition = true

	var actuel = get_niveau_actuel()
	get_tree().call_deferred("change_scene_to_file",
		"res://Scenes/niveau_%d.tscn" % actuel)

func _on_scene_changed():
	_en_transition = false
