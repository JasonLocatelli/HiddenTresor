extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		GameManager.visibilityStore(true)
		AudioManager.music_outwater_to_shop()


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		GameManager.visibilityStore(false)
		AudioManager.music_shop_to_outwater()
