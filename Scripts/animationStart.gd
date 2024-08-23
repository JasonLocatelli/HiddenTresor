extends Sprite2D

@export var nameAnimation = "herbe"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play(nameAnimation)
