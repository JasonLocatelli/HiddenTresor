extends Node

var player : CharacterBody2D
var hud : HUD
var timer : Timer
var gameSlot : int = 0
# Pieces posséder
var coins : int = 0
# Niveau de la mutation pour chaque amélioration diferrent
var powerLevel = 0
var speedLevel = 0
var oxygeneLevel = 0
var dashLevel = 0


# Méthode chargée de chercher les nodes afin de les affecter.
func find_nodes():
	player = get_tree().get_first_node_in_group("player")
	hud = get_tree().get_first_node_in_group("hud")
	timer = player.timerOxygene
	
func _process(_delta):
	if hud != null && player != null:
		hud.updateValuePbOxygen(timer.time_left)

# Méthode chargée de charger le jeu.
func load_game_scene():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	hud.updateMaxValuePbOxygen(player.getMaxOxygene())
	hud.updateValuePbOxygen(player.getMaxOxygene())

# ajoute des pieces
func add_coins(numberOfCoin):
	coins = coins + numberOfCoin
	hud.update_coins_quantity()

# Enleve des pieces
func remove_coins(numberOfCoin):
	coins = coins - numberOfCoin
	hud.update_coins_quantity()

func visibilityStore(visibility):
	hud.storeVisibility(visibility)

func getLevelFromItem(item):
	match item :
		PowerDb.UPGRADE.SPEED : 
			return  speedLevel
		PowerDb.UPGRADE.DASH : 
			return  dashLevel
		PowerDb.UPGRADE.POWER : 
			return  powerLevel
		PowerDb.UPGRADE.OXYGENE : 
			return  oxygeneLevel

func addLevelFromItem(item):
	match item :
		PowerDb.UPGRADE.SPEED : 
			speedLevel = speedLevel + 1
		PowerDb.UPGRADE.DASH : 
			dashLevel = dashLevel + 1
		PowerDb.UPGRADE.POWER : 
			powerLevel = powerLevel + 1
		PowerDb.UPGRADE.OXYGENE : 
			oxygeneLevel = oxygeneLevel + 1

func resetElement():
	coins = 0
	powerLevel = 0
	speedLevel = 0
	oxygeneLevel = 0
	dashLevel = 0
