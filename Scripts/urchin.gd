extends FollowPathController
class_name Urchin

var target
@export var damage = 3
@export var timeAttack = 1

func _ready():
	$AnimationPlayer.play("idle")
	
func _physics_process(delta):
	super._physics_process(delta)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.dead()

func _on_range_attack_body_entered(body):
	if body.is_in_group("player"):
		$TimerAttack.start()
		target = body
		body.takeDamage(damage)
		
func _on_range_attack_body_exited(_body):
	$TimerAttack.stop()

func _on_timer_attack_timeout():
	target.takeDamage(damage)
