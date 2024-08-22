extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.grab_focus()
	$AnimationPlayer.play("scrolling")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
