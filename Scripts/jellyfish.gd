extends CharacterBody2D

@export var life = 5
@export var damage = 4
@export var timerAttack = 1.0
@export var speed = 100.0
var target
@onready var nav: NavigationAgent2D = $NavigationAgent2D


func _ready():
	$TimerAttack.wait_time = timerAttack
	seekerSetup()
	call_deferred("seekerSetup")
	
func seekerSetup():
	await get_tree().physics_frame
	if target:
		attributePosWhenRaycastDetectPlayer()

func attributePosWhenRaycastDetectPlayer():
	$RayCast2D.target_position = global_position - target.global_position
	var getCollider = $RayCast2D.get_collider()
	if getCollider != null && getCollider.is_in_group("player"):
		nav.target_position = target.global_position
		
func _physics_process(delta):	
	if target:
		attributePosWhenRaycastDetectPlayer()
	if nav.is_navigation_finished():
		return
	
	var currentAgentPosition = global_position
	var netxPathPosition = nav.get_next_path_position()
	velocity = currentAgentPosition.direction_to(netxPathPosition) * speed
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		print("test")
		target = body
		$RayCast2D.target_position = body.global_position

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		target = null
		$RayCast2D.target_position = Vector2.ZERO

func _on_range_attack_body_entered(body):
	if body.is_in_group("player"):
		$TimerAttack.start()
		body.takeDamage(damage)

func _on_range_attack_body_exited(body):
	if body.is_in_group("player"):
		$TimerAttack.stop()

func takeDamage(value):
	life -= value
	AudioManager.playAudioSlash()
	if life <= 0:
		dead()
	
func dead():
	queue_free()


func _on_timer_attack_timeout():
	target.takeDamage(damage)
