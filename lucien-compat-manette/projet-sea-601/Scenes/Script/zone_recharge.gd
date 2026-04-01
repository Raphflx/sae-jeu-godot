extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.has_method("commencer_recharge"):
		body.commencer_recharge()

func _on_body_exited(body):
	if body.has_method("arreter_recharge"):
		body.arreter_recharge()
