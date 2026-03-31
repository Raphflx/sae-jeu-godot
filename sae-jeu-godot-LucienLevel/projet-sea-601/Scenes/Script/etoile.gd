extends Node2D

var etoiles = []   # liste qui stocke toutes les étoiles
var nb_etoiles = 50  # nombre d'étoiles à afficher

func _ready():
	# Génère les étoiles avec des positions et vitesses aléatoires
	for i in nb_etoiles:
		etoiles.append({
			"pos": Vector2(randf_range(0, 1152), randf_range(0, 648)), # position aléatoire
			"vitesse": randf_range(20, 80),  # vitesse aléatoire
			"taille": randf_range(1, 3)      # taille aléatoire entre 1 et 3 pixels
		})

func _process(delta):
	# Déplace chaque étoile vers le bas à chaque frame
	for e in etoiles:
		e["pos"].y += e["vitesse"] * delta 
		# Si l'étoile sort de l'écran en bas -> elle réapparaît en haut
		if e["pos"].y > 648:
			e["pos"].y = 0
			e["pos"].x = randf_range(0, 1152)  # nouvelle position X aléatoire
	queue_redraw()  # Redessine les étoiles

func _draw():
	# Etoile = petit carré blanc
	for e in etoiles:
		draw_rect(Rect2(e["pos"], Vector2(e["taille"], e["taille"])), Color.WHITE)
