extends CharacterBody2D

# Vélocité de saut, définie comme une constante pour être utilisée lors de la détection du saut.
const JUMP_VELOCITY = -300.0
const JUMP_VELOCITY_ON_WATER = -80.0

const UP_VELOCITY_ON_SWIMMING = -55.0
# Initialisation du temps d'oxygène restant appliqué à TimerOxygen
@export var initTimerOxygen = 10
# Initialisation du temps de dash
@export var initTimeDash = 4
# Initialisation de la resistance
@export var initResistance = 0
# Vitesse maximale du personnage en pixels par seconde.
var max_speed = 225
# Vitesse de chute dans l'eau
var max_speed_fall_on_water = 90
# Force de gravité appliquée au personnage, récupérée depuis les paramètres du projet.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravityOnWater = 80
# Valeur en temps reel de l'oxygène
var enableOxygen = false
# Valeur pour activer l'attaque
var enableAttack = false
# Si <code>true<code> alors il est en vie sinon mort
var isDead = false
var damage = 2
var resistance = 0
var tween
var dash = false
var dashVelocity = 12
var dashVelocityOutWater = 4
@onready var timerOxygene = $TimerOxygen

# Fonction principale appelée à chaque frame, dédiée à la physique du jeu.
# 'delta' est le temps écoulé depuis la dernière frame, utilisé pour garantir des mouvements indépendants de la performance.
func _physics_process(delta):
	if !isDead:
		# Appliquer la gravité lorsque le personnage n'est pas au sol.
		if not is_on_floor():
			if !enableOxygen:
				velocity.y += gravity * delta
			else:
				velocity.y += gravityOnWater * delta
				velocity.y = clamp(velocity.y, -max_speed_fall_on_water, max_speed_fall_on_water)
		# Gérer le saut du personnage.
		# Si le personnage est au sol et que le joueur appuie sur la touche de saut, appliquer la vélocité de saut.
		if is_on_floor() && Input.is_action_pressed("jump"):
			AudioManager.play_human_jump()
			if !enableOxygen:
				velocity.y = JUMP_VELOCITY
			else:
				velocity.y = JUMP_VELOCITY_ON_WATER
		
		if Input.is_action_pressed("jump") && !is_on_floor() && enableOxygen && GameManager.swimmingLevel > 0:
			velocity.y = UP_VELOCITY_ON_SWIMMING
		
		if Input.is_action_just_pressed("attack") && GameManager.clawLevel > 0 && !$AnimationPlayer.is_playing():
				$AnimationPlayer.play("attack")

		if Input.is_action_just_pressed("entranceBoss1"):
			position = GameManager.posEntranceBoss1.global_position
			
		# Déterminer la direction horizontale en fonction des touches appuyées (droite ou gauche).
		# La fonction 'int()' convertit la valeur booléenne en entier (1 pour vrai, 0 pour faux).
		var x_dir = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
		
		# Appliquer la vitesse horizontale en fonction de la direction détectée.
		# La vitesse est divisée par 1.5 pour un contrôle plus précis du personnage.
		# On applique la velocité du dash quand il est en cours d'execution.
		if dash:
			# On applique pas la même velocity du dash en dehors et dans l'eau.
			if enableOxygen:
				velocity.x = x_dir * ((getMaxSpeed() / 1.5) * dashVelocity)
			else:
				velocity.x = x_dir * ((getMaxSpeed() / 1.5) * dashVelocityOutWater)
		else:
			velocity.x = x_dir * ((getMaxSpeed() / 1.5))
		
		if GameManager.dashLevel > 0 && Input.is_action_just_pressed("dash") && $TimerDash.is_stopped():
			dash = true
			if tween:
				tween.stop()
			tween = create_tween()
			$AudioDash.play()
			tween.tween_property(self, "dash", false, 0.2).set_ease(Tween.EASE_OUT)
			$TimerDash.start(getMaxDashTime())
			
		if x_dir == 1:
			$AnimatedSprite2D.flip_h = false
			$rangeAttackUnderWater.scale.x = x_dir
			if enableOxygen:
				$AnimatedSprite2D.play("swim")
		elif x_dir == -1:
			$AnimatedSprite2D.flip_h = true
			$rangeAttackUnderWater.scale.x = x_dir
			if enableOxygen:
				$AnimatedSprite2D.play("swim")
		else:
			$AnimatedSprite2D.pause()
		
		# Appliquer le mouvement au personnage en utilisant la fonction 'move_and_slide()'.
		# Cette fonction gère automatiquement les collisions et permet au personnage de glisser le long des surfaces.
		move_and_slide()
	else :
		if not is_on_floor():
			velocity.x = 0
			velocity.y += gravityOnWater * delta
			velocity.y = clamp(velocity.y, -max_speed_fall_on_water, max_speed_fall_on_water)
			move_and_slide()
		else :
			velocity.y = 0
			move_and_slide()

# Méthode chargée de démarrer le timer d'oxygène.
func start_timer_oxygen():
	$TimerOxygen.wait_time = getMaxOxygene()
	$TimerOxygen.start()
	GameManager.hud.updateMaxValuePbOxygen(getMaxOxygene())	
	GameManager.hud.set_visible_pb_oxygen(true)
	enableOxygen = true
	
# Méthode chargée d'arrêter le timer d'oxygène.
func stop_timer_oxygen():
	$TimerOxygen.stop()
	enableOxygen = false

func dead():
	isDead = true
	#CollisionShape2D.queue_free()
	timerOxygene.stop()
	$AnimatedSprite2D.pause()
	AudioManager.play_human_drowning()
	if GameManager.firstGame :
		GameManager.firstGame = false
	SaveAndLoad.saveDataFromSaveFile(GameManager.gameSlot)
	GameManager.hud.displayGameOver()

func _on_timer_oxygen_timeout():
	dead()
	
func takeDamage(pValue):
	var newTime = timerOxygene.time_left - takeDamageTotal(pValue)
	if newTime > 0:
		timerOxygene.start(timerOxygene.time_left - pValue)
		AudioManager.play_human_hurt()
	elif !isDead:
		dead()

func takeDamageTotal(pValue):
	return max(1,pValue - getMaxResistance())

func _on_area_2d_body_entered(body):
	if body is CPUParticles2D:
		print("Collision detectée")

func play_pick_up_coin():
	$AudioPickUpCoin.play()

func getMaxSpeed():
	return max (max_speed,max_speed + max_speed * GameManager.speedLevel)
	
func getMaxOxygene():
	return max(initTimerOxygen, initTimerOxygen + initTimerOxygen * GameManager.oxygeneLevel)

func getMaxDashTime():
	return max (initTimeDash, initTimeDash * GameManager.dashLevel)
	
func getMaxResistance():
	return max (initResistance,initResistance + GameManager.resistanceLevel + 3)
	
func getMaxStrengh():
	return max(damage, damage + GameManager.strenghLevel + 3)
	
func playAnimationAttack():
	$AnimationPlayer.play("attack")

func _on_range_attack_under_water_body_entered(body):
	if body.is_in_group("enemy"):
		body.takeDamage(getMaxStrengh())
