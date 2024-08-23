extends CharacterBody2D
class_name Projectile
@export var speed = 150
@export var timerExist = 20
@export var damage = 4
@export var texture : Texture2D
var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	
func _physics_process(_delta):
	velocity = Vector2(0, -speed).rotated(dir)
	move_and_slide()
