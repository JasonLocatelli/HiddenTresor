extends Projectile

func _ready():
	super._ready()
	if texture != null:
		$Sprite2D.texture = texture
	$TimerExist.start(timerExist)
	
func _physics_process(delta):
	super._physics_process(delta)

func _on_timer_exist_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.takeDamage(damage)
		queue_free()
