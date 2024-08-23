extends Projectile

func _ready():
	super._ready()
	if texture != null:
		$Sprite2D.texture = texture
	$TimerExist.start(timerExist)
	
func _physics_process(delta):
	super._physics_process(delta)
	#for i in get_slide_collision_count():
	#	var collision = get_slide_collision(i)
	#	if collision != null && !collision.get_collider().is_in_group("player"):
	#		queue_free()

func _on_timer_exist_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.takeDamage(damage)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered():
	visible = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	visible = false
