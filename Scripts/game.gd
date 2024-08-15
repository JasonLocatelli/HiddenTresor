extends Node2D
var blockStart = false
func _ready():
	GameManager.find_nodes()

func _on_trigger_start_body_entered(body):
	if body.is_in_group("player") && !blockStart:
		$Ennemies/Urchin.startFollowPath = true
		$Ennemies/Urchin2.startFollowPath = true
		blockStart = true
