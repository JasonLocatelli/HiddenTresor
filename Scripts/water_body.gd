extends Node2D

# Constants
@export var k = 0.015 # Constante de rigidité du ressort
@export var d = 0.03 # Constante d'amortissement du ressort
@export var spread = 0.0003 # Constante de propagation des ondes à travers les ressorts
@export var distance_between_springs = 32 # Distance entre chaque ressort le long de l'eau
@export var spring_number = 6 # Nombre total de ressorts (segments de l'eau)
@export var border_thickness = 1.1 # Épaisseur de la bordure de l'eau
@export var depth = 1000 # Profondeur de la zone d'eau

# Ressources prêtes à l'emploi
@onready var water_spring = preload("res://Scenes/water_spring.tscn") # Scène du ressort d'eau préchargée
@onready var water_polygon = $WaterPolygon # Référence au noeud de polygone de l'eau
@onready var water_border = $WaterBorder # Référence à la bordure de l'eau

# Variables
var springs = [] # Liste contenant les instances des ressorts
var passed = 8 # Nombre de passes de simulation de propagation
var target_height = global_position.y # Hauteur cible pour le niveau de l'eau
var bottom = target_height + depth # Position de la limite inférieure de l'eau

# Fonction appelée lorsque le noeud est prêt
func _ready():
	# Configure la bordure de l'eau
	water_border.width = border_thickness
	# Initialise les ressorts et les ajoute en tant qu'enfants de la scène
	for i in range(spring_number):
		var x_position = distance_between_springs * i
		var instance = water_spring.instantiate()
		add_child(instance)
		springs.append(instance)
		instance.initialize(x_position, i)
		instance.set_collision_width(distance_between_springs)
		instance.connect("splash", splash)
	
	# Définir la forme et la position de la zone de collision de l'eau
	var total_lenght = distance_between_springs * (spring_number - 1)
	var rectangle = RectangleShape2D.new().duplicate()
	var rect_position = Vector2(total_lenght /2, depth /2)
	var rect_extends = Vector2(total_lenght, depth)
	$Water_body_area.position = rect_position
	rectangle.size = rect_extends
	$Water_body_area/water_body_collision.set_shape(rectangle)

# Fonction appelée à chaque frame de simulation physique
func _physics_process(delta):
	# Met à jour chaque ressort avec les constantes de simulation
	for i in springs:
		i.water_update(k, d)
	
	var left_deltas = [] # Liste des décalages des ressorts vers la gauche
	var right_deltas = [] # Liste des décalages des ressorts vers la droite
	for i in range(springs.size()):
		left_deltas.append(0)
		right_deltas.append(0)
	
	# Simule la propagation des ondes à travers les ressorts
	for j in range(passed):
		for i in range(springs.size()):
			if i > 0:
				left_deltas[i] = spread * (springs[i].height - springs[i-1].height)
				springs[i-1].velocity += left_deltas[i]
			if i < springs.size() - 1:
				right_deltas[i] = spread * (springs[i].height - springs[i+1].height)
				springs[i+1].velocity += right_deltas[i]
	
	new_border()
	draw_water_body()

# Gère les éclaboussures d'eau lorsque quelque chose entre en collision avec l'eau
func splash(index, speed):
	if index >= 0 and index < springs.size():
		springs[index].velocity += speed

# Fonction appelée à chaque frame, mais actuellement vide
func _process(delta):
	pass

# Dessine le polygone représentant la surface de l'eau
func draw_water_body():
	var curve = water_border.curve 
	var points = Array(curve.get_baked_points())
	var water_polygon_points = points
	var first_index = 0
	var last_index = water_polygon_points.size() - 1
	water_polygon_points.append(Vector2(water_polygon_points[last_index].x, bottom))
	water_polygon_points.append(Vector2(water_polygon_points[first_index].x, bottom))
	water_polygon_points = PackedVector2Array(water_polygon_points)
	water_polygon.polygon = water_polygon_points

# Met à jour la bordure de l'eau pour correspondre à la nouvelle forme
func new_border():
	var curve = Curve2D.new().duplicate()
	var surface_points = []
	for i in range(springs.size()):
		surface_points.append(springs[i].position)
	for i in range(surface_points.size()):
		curve.add_point(surface_points[i])
	water_border.curve = curve
	water_border.smooth(true)
	water_border.queue_redraw()

# Gère les événements lorsqu'un corps entre dans la zone d'eau
func _on_water_body_area_body_entered(body):
	if body.is_in_group("player"):
		body.start_timer_oxygen() # Commence le timer d'oxygène
		body.max_speed = body.max_speed / 2 # Réduit la vitesse maximale du joueur

# Gère les événements lorsqu'un corps sort de la zone d'eau
func _on_water_body_area_body_exited(body):
	if body.is_in_group("player"):
		body.stop_timer_oxygen() # Arrête le timer d'oxygène
		body.max_speed = body.max_speed * 2 # Rétablit la vitesse maximale du joueur
