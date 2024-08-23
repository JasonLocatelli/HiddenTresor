extends Area2D

# Le nombre de pieces que cela va apporter
@export var coinsToAdd = 5

# Au contact avec le joueur, lui donne des pieces et disparait
func _on_body_entered(body):
	if body.is_in_group("Player"):
		GameManager.add_coins(coinsToAdd)
		AudioManager.play_pick_up_coin()
		queue_free()
