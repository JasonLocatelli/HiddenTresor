extends Node

var player : CharacterBody2D
var hud : HUD

# Appelé quand le premier node entre dans la scène
func _ready():
	player = get_tree().get_first_node_in_group("player")
	hud = get_tree().get_first_node_in_group("hud")
func _physics_process(delta):
	if hud != null && player != null:
		hud.updateMaxValuePbOxygen(player.initTimerOxygen)
		hud.updateValuePbOxygen(player.timerOxygen)
		
