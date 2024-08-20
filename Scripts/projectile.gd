extends CharacterBody2D

@export var SPEED = 150

var damage = 4
var dir : float
var spawnPos : Vector2
var spawnRot : float
var timerExist = 20

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	
func _physics_process(delta):
	velocity = Vector2(0, -SPEED).rotated(dir)
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.takeDamage(damage)
		queue_free()

func _on_timer_exist_timeout():
	queue_free()
