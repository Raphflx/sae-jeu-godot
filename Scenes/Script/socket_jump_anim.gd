extends Label

func _ready():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.8)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.8)
