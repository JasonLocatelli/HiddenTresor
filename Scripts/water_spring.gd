extends Node2D

# Références aux nœuds dans la scène
@onready var collision = $Area2D/CollisionShape2D # Référence au nœud de la forme de collision associée à la zone 2D

# Variables
var velocity = 0 # Vitesse actuelle du ressort sur l'axe Y
var force = 0 # Force appliquée au ressort
var height = 0 # Hauteur actuelle du ressort
var target_height = 0 # Hauteur cible du ressort
var index = 0 # Indice de ce ressort particulier dans la liste des ressorts
var motion_factor = 0.008 # Facteur de mouvement utilisé pour calculer l'impact lors des collisions
var collided_with = null # Référence au dernier corps entré en collision avec ce ressort

# Signal émis lorsqu'un éclaboussement est généré
signal splash

# Fonction pour mettre à jour la position et la vitesse du ressort en fonction des constantes de simulation
func water_update(sprintConstant, dampening):
	height = position.y # Mise à jour de la hauteur actuelle
	var x = height - target_height # Calcul du décalage par rapport à la hauteur cible
	var loss = -dampening * velocity # Calcul de la perte de vitesse due à l'amortissement
	force = - sprintConstant * x + loss # Calcul de la force résultante appliquée au ressort
	velocity += force # Mise à jour de la vitesse avec la force calculée
	position.y += velocity # Mise à jour de la position en fonction de la nouvelle vitesse

# Fonction d'initialisation du ressort avec sa position et son identifiant
func initialize(x_position, id):
	height = position.y
	target_height = position.y
	velocity = 0
	position.x = x_position # Positionne le ressort sur l'axe X
	index = id # Définit l'indice de ce ressort

# Définit la largeur de la collision en fonction d'une valeur donnée
func set_collision_width(value):
	var extents = collision.shape.size # Récupère les dimensions actuelles de la forme de collision
	var new_extents = Vector2(value/1.5, extents.y) # Calcule les nouvelles dimensions avec la largeur donnée
	collision.shape.size = new_extents # Applique les nouvelles dimensions à la forme de collision

# Fonction appelée lorsqu'un corps entre en collision avec la zone 2D
func _on_area_2d_body_entered(body):
	if body == collided_with: # Si le corps est le même que le précédent, ne rien faire
		return
	collided_with = body # Enregistre le corps avec lequel la collision a eu lieu
	if (!(body is StaticBody2D)): # Si le corps n'est pas un corps statique
		var speed = body.velocity.y * motion_factor # Calcule la vitesse d'impact avec le facteur de mouvement
		emit_signal("splash", index, speed) # Émet un signal "splash" avec l'indice du ressort et la vitesse calculée
