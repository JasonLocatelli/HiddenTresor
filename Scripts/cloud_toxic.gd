extends Node2D

@export var dmgPerSecPoison = 1
@export var timeAtkPerSecPoison = 1
var target

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayerParticles.play("playParticle")
	
func _on_timer_poison_timeout():
	target.takeDamage(dmgPerSecPoison)

func _on_range_particle_body_entered(body):
	if body.is_in_group("player"):
		$TimerPoison.start()
		target = body
		body.takeDamage(dmgPerSecPoison)

func _on_range_particle_body_exited(body):
	$TimerPoison.stop()

func _on_animation_player_particles_animation_finished(anim_name):
	queue_free()
