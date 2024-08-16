class_name SmoothPath
extends Path2D

# Variables exportées
@export var spline_length = 20 # Longueur des splines utilisées pour lisser le chemin
@export var color: Color = Color(1,1,1,1) # Couleur utilisée pour dessiner le chemin

# Variables internes
var width = 8 # Largeur de la ligne lors du dessin du chemin

# Fonction pour redresser les segments du chemin en les rendant linéaires
func straighten(value):
	if not value: return # Si la valeur est False, on ne fait rien
	for i in range(curve.get_point_count()):
		curve.set_point_in(i, Vector2()) # Supprime les tangentes entrantes
		curve.set_point_out(i, Vector2()) # Supprime les tangentes sortantes

# Fonction pour lisser le chemin en utilisant des splines
func smooth(value):
	if not value: return # Si la valeur est False, on ne fait rien

	var point_count = curve.get_point_count()
	for i in point_count:
		if i > 0 and i < point_count - 1:
			var spline = _get_spline(i) # Calcule la spline pour le point
			curve.set_point_in(i, -spline) # Définir la tangente entrante
			curve.set_point_out(i, spline) # Définir la tangente sortante

# Fonction pour obtenir la spline entre deux points adjacents
func _get_spline(i):
	var last_point = _get_point(i - 1) # Point précédent
	var next_point = _get_point(i + 1) # Point suivant
	var spline = last_point.direction_to(next_point) * spline_length # Calcule la spline
	return spline

# Fonction pour obtenir la position d'un point avec gestion des indices en dehors des limites
func _get_point(i):
	var point_count = curve.get_point_count()
	i = wrapi(i, 0, point_count) # Assure que l'index est dans la plage valide
	if i > 1 and i < point_count - 1:
		return curve.get_point_position(i) # Renvoie la position normale du point
	elif i <= 1:
		return Vector2(curve.get_point_position(1).x - spline_length, curve.get_point_position(1).y) # Extrapole la position du premier point
	elif i >= point_count - 1:
		return Vector2(curve.get_point_position(point_count - 1).x + spline_length, curve.get_point_position(point_count - 1).y) # Extrapole la position du dernier point

# Fonction de dessin pour afficher le chemin lissé ou redressé
func _draw():
	var points = curve.get_baked_points() # Obtient les points cuits de la courbe
	if points:
		draw_polyline(points, color, width, true) # Dessine une ligne suivant les points avec la couleur et la largeur spécifiées
