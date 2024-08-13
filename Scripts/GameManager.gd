extends Node

var player : CharacterBody2D
var hud : HUD

func _ready():
	find_nodes()

# Méthode chargée de chercher les nodes afin de les affecter.
func find_nodes():
	player = get_tree().get_first_node_in_group("player")
	hud = get_tree().get_first_node_in_group("hud")
	
func _physics_process(delta):
	if hud != null && player != null:
		hud.updateMaxValuePbOxygen(player.initTimerOxygen)
		hud.updateValuePbOxygen(player.timerOxygen)

# Méthode chargée de charger le jeu.
func load_game_scene():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
