extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -400.0

var target
var life = 30
@export var initLife = 30
@export var damage = 7 # Dommage du poisson
@export var timeAttack = 1 # Cooldown de l'attaque du poisson
@export var timeShoot = 0.65 # Cooldown de l'attaque du poisson
var _frames_since_facing_update: int = 0
var _moved_this_frame: bool = false
var countToStone = 0
@onready var main = get_tree().get_root().get_node("Game")
@onready var bubblePoison = load("res://Scenes/bubblePoison.tscn")

func _ready():
	$TimerShoot.wait_time = timeShoot
	target = get_tree().get_first_node_in_group("player")
	life = initLife
	$TimerAttack.wait_time = timeAttack
	$AnimatedSprite2D.play("100")
	
func enableDareDevilSquid():
	AudioManager.audioUnderwaterToBoss1()
	$BTPlayer.active = true

func _physics_process(_delta: float) -> void:
	_post_physics_process.call_deferred()

func _post_physics_process() -> void:
	if not _moved_this_frame:
		velocity = lerp(velocity, Vector2.ZERO, 0.5)
	_moved_this_frame = false

func move(_p_velocity: Vector2, dir) -> void:
	velocity = Vector2(0, -SPEED).rotated(dir)
	move_and_slide()
	_moved_this_frame = true

## Update agent's facing in the velocity direction.
func update_facing() -> void:
	_frames_since_facing_update += 1
	if _frames_since_facing_update > 3:
		face_dir(velocity.x)

## Face specified direction.
func face_dir(dir: float) -> void:
	if dir > 0.0 and scale.x < 0.0:
		scale.x = 1.0;
		_frames_since_facing_update = 0
	if dir < 0.0 and scale.x > 0.0:
		scale.x = -1.0;
		_frames_since_facing_update = 0

## Returns 1.0 when agent is facing right.
## Returns -1.0 when agent is facing left.
func get_facing() -> float:
	return signf(scale.x)
	
## Is specified position inside the arena (not inside an obstacle)?
func is_good_position(p_position: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	var params := PhysicsPointQueryParameters2D.new()
	params.position = p_position
	params.collision_mask = 1 # Obstacle layer has value 1
	var collision := space_state.intersect_point(params)
	return collision.is_empty()

func isCollideWall():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision != null && !collision.get_collider().is_in_group("player"):
			countToStone += 1
			print(countToStone)
			return true
	return false

func takeDamage(value):
	life -= value
	if life <= 0:
		dead()
	else:
		AudioManager.playAudioSlash()
	print(life)
	var calculPercent25 = life * (25.0/100.0)
	if life > calculPercent25 && life <= initLife/2.0:
		AudioManager.editPitchAudioMusicBoss1(1.1)
		$AnimatedSprite2D.play("50")
		if $TimerShoot.is_stopped():
			$TimerShoot.start()
	elif life > 0 && life <= calculPercent25:
		$AnimatedSprite2D.play("25")
		
func dead():
	AudioManager.playMusicProcedural()
	AudioManager.playAudioWin()
	AudioManager.audioBoss1ToUnderwater()
	GameManager.deleteDoorBoss2()
	GameManager.canOpenChest = true
	queue_free()

func launchBubble():
	var directionToTarget = global_position.direction_to(target.position).angle()+deg_to_rad(90)
	var bubblePoisonInstance = bubblePoison.instantiate()
	bubblePoisonInstance.spawnPos = global_position
	bubblePoisonInstance.dir = directionToTarget
	bubblePoisonInstance.spawnRot = directionToTarget 
	main.add_child.call_deferred(bubblePoisonInstance)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		target.takeDamage(damage)
		$TimerAttack.start()

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		$TimerAttack.stop()

func _on_timer_attack_timeout():
	target.takeDamage(damage)

func _on_timer_shoot_timeout():
	launchBubble()


func _on_visible_on_screen_notifier_2d_screen_entered():
	visible = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	visible = false
