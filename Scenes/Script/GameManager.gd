extends Node

var niveau_actuel = 1
var niveau_max    = 3

func niveau_suivant():
	niveau_actuel += 1
	if niveau_actuel > niveau_max:
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	else:
		get_tree().change_scene_to_file(
			"res://scenes/niveau_%d.tscn" % niveau_actuel
		)

func recommencer_niveau():
	get_tree().change_scene_to_file(
		"res://scenes/niveau_%d.tscn" % niveau_actuel
	)
