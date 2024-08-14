extends Node

var player : CharacterBody2D
var hud : HUD
var timer : Timer
# Pieces posséder
var coins : int = 0

func _ready():
	find_nodes()

# Méthode chargée de chercher les nodes afin de les affecter.
func find_nodes():
	player = get_tree().get_first_node_in_group("player")
	hud = get_tree().get_first_node_in_group("hud")
	timer = player.timerOxygene
	
func _process(delta):
	if hud != null && player != null:
		hud.updateValuePbOxygen(timer.time_left)
		
# Méthode chargée de charger le jeu.
func load_game_scene():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	hud.updateMaxValuePbOxygen(player.initTimerOxygen)
	hud.updateValuePbOxygen(player.initTimerOxygen)

# ajoute des pieces
func add_coins(numberOfCoin):
	coins = coins + numberOfCoin
	hud.update_coins_quantity()

# Enleve des pieces
func remove_coins(numberOfCoin):
	coins = coins - numberOfCoin
	hud.update_coins_quantity()
