extends CharacterBody2D
class_name FollowPathController

@export var pathFollow : PathFollow2D
@export var loop = false # Boucler sur le chemin
@export var startFollowPath = false
@export var speed = 1.9 # Vitesse du sprite

var sensPositive : bool # Indique le sens du mouvement

func _ready():
	sensPositive = true

func _physics_process(delta):
	if pathFollow != null:
		manage_follow_path(delta)
		
# Méthode chargée de gérer les mouvements du sprite.
func manage_follow_path(delta):
	if startFollowPath: 
		# On vérifie le sens du mouvement 
		if sensPositive: 
			pathFollow.progress_ratio += speed * delta
		elif loop:
			pathFollow.progress_ratio -= speed * delta

	if pathFollow.progress_ratio == 1:
		sensPositive = false
	elif pathFollow.progress_ratio == 0:
		sensPositive = true
		
	global_position = pathFollow.global_position
