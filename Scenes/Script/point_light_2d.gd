extends PointLight2D

func _ready():
	add_to_group("player_light")
	enabled = false
	blend_mode = Light2D.BLEND_MODE_MIX
	
	var image = Image.create(256, 256, false, Image.FORMAT_RGBA8)
	for y in range(256):
		for x in range(256):
			var dx = (x - 128.0) / 128.0
			var dy = (y - 128.0) / 128.0
			var dist = sqrt(dx*dx + dy*dy)
			var alpha = clamp(1.0 - dist, 0.0, 1.0)
			alpha = alpha * alpha  # courbe douce
			image.set_pixel(x, y, Color(1, 0.9, 0.6, alpha))
	
	var tex = ImageTexture.create_from_image(image)
	texture = tex
