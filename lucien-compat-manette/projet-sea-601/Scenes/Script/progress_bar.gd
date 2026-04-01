extends ProgressBar

var _icone_ajoutee = false

func _ready():
	size = Vector2(220, 20)
	position = Vector2(50, 16)
	show_percentage = false

	# Cache les styles par défaut
	add_theme_stylebox_override("background", StyleBoxEmpty.new())
	add_theme_stylebox_override("fill", StyleBoxEmpty.new())

func _process(_delta):
	queue_redraw()
	# Ajoute l'icône une seule fois
	if not _icone_ajoutee:
		var icone = Label.new()
		icone.text = "⚡"
		icone.position = Vector2(-26, -1)
		icone.add_theme_font_size_override("font_size", 18)
		add_child(icone)
		_icone_ajoutee = true

func _draw():
	var w = size.x
	var h = size.y
	var pct = clamp(value / max_value, 0.0, 1.0)
	var is_low = pct < 0.2
	var rayon = h / 2.0

	# Fond arrondi
	var fond = StyleBoxFlat.new()
	fond.bg_color = Color(0.03, 0.06, 0.15)
	fond.border_color = Color(0.1, 0.22, 0.42)
	fond.set_border_width_all(2)
	fond.set_corner_radius_all(int(rayon))
	fond.draw(get_canvas_item(), Rect2(0, 0, w, h))

	# Remplissage arrondi
	if pct > 0.01:
		var fill_color = Color(0.98, 0.78, 0.1)
		if is_low:
			var pulse = abs(sin(Time.get_ticks_msec() * 0.005))
			fill_color = Color(0.88, 0.29, 0.29)
			fill_color.a = 0.6 + pulse * 0.4

		var fill = StyleBoxFlat.new()
		fill.bg_color = fill_color
		fill.set_corner_radius_all(int(rayon))
		fill.draw(get_canvas_item(), Rect2(2, 2, (w - 4) * pct, h - 4))

		# Reflet
		var reflet = StyleBoxFlat.new()
		reflet.bg_color = Color(1, 1, 1, 0.12)
		reflet.set_corner_radius_all(int(rayon))
		reflet.draw(get_canvas_item(), Rect2(2, 2, (w - 4) * pct, (h - 4) * 0.45))

	# Séparateurs
	for i in 4:
		var x = w * (i + 1) / 5.0
		draw_line(Vector2(x, 4), Vector2(x, h - 4), Color(0, 0, 0, 0.25), 1)

	# Valeur
	draw_string(
		ThemeDB.fallback_font,
		Vector2(w + 10, h * 0.5 + 5),
		str(int(value)),
		HORIZONTAL_ALIGNMENT_LEFT,
		-1, 13,
		Color(0.98, 0.78, 0.1)
	)
