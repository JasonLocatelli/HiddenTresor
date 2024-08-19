extends Node2D

@export var dmgPerSecPoison = 1
@export var timeAtkPerSecPoison = 1
var target
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayerParticles.play("playParticle")
	$AudioGas.play()

# Méthode chargée de faire perdre de l'oxygène au joueur quand le cooldown du poison est fini.
func _on_timer_poison_timeout():
	target.takeDamage(dmgPerSecPoison)

# Méthode chargée d'activer le timer du poison quand le joueur entre dans la portée de celui-ci.
func _on_range_particle_body_entered(body):
	if body.is_in_group("player"):
		$TimerPoison.start()
		target = body
		body.takeDamage(dmgPerSecPoison)

# Méthode chargée d'arrêter le timer du poisson qsuand le joueur quitte la portée de celui-ci.
func _on_range_particle_body_exited(_body):
	$TimerPoison.stop()

# Méthode chargée de supprimer les particules quand sont l'animation est fini.
func _on_animation_player_particles_animation_finished(_anim_name):
	queue_free()
