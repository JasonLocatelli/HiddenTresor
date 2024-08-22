extends Node2D


func _ready():
	if GameManager.firstGame:
		$".".visible = false
		$Area2D/CollisionShape2D.disabled = true
	else :
		$AnimationPlayer.play("floating")

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		GameManager.visibilityStore(true)
		
		AudioManager.music_outwater_to_shop()


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		GameManager.visibilityStore(false)
		AudioManager.music_shop_to_outwater()
