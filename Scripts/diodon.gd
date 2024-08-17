extends FollowPathController
class_name Porcupinefish

var detect
var target

@export var life = 5 # Vie du poisson
@export var damage = 3 # Dommage du poisson
@export var timeAttack = 1 # Cooldown de l'attaque du poisson
@export var dmgPerSecPoison = 1 # Dommage par secondes
@export var timeAtkPerSecPoison = 1 # Cooldown des dmg du poison
@export var timeReloadPoison = 7 # Cooldown du rechargement du poisson
@export var timePuffy = 5 # Cooldown en mode "gonflé"
@export var timeVulnerable = 3 # Cooldown de la vulnérabilité

@onready var cloudToxic = load("res://Scenes/cloud_toxic.tscn")

func _ready():
	$TimerAttack.wait_time = timeAttack
	$TimerReloadPoison.wait_time = timeReloadPoison
	$TimerVulnerable.wait_time = timeVulnerable
	$TimerPuffy.wait_time = timePuffy
	
func _physics_process(delta):
	super._physics_process(delta)
 
# Méthode chargée de verifier si le joueur se trouve à la portée de vue du poisson.
func _on_range_detect_body_entered(body):
	# On vérifie si body est un joueur et que le TimerWaiToMove est arrêté
	if body.is_in_group("player") && $TimerWaitToMove.is_stopped():
		detect = true
		startFollowPath = false
		# On gonffle le poisson quand le rechargement du nuage et la vulnérabilité sont arrêté.
		if $TimerReloadPoison.is_stopped() && $TimerVulnerable.is_stopped():
			$AnimationPlayer.play("increaseScale")

# Méthode chargée de vérifier si le joueur se trouve en dehors de la portée de vue du poisson.
func _on_range_detect_body_exited(body):
	# On vérifie si body est un joueur
	if body.is_in_group("player"):
		detect = false
		$TimerWaitToMove.start() # On marque un temps d'arrêter au poisson

# Méthode chargée de continuer les mouvements du poisson quand le timer est fini.
func _on_timer_wait_to_move_timeout():
	if !detect:
		# Méthode chargée de dégonffler le poisson
		if !$TimerPuffy.is_stopped():
			$AnimationPlayer.play_backwards("decreaseScale", -1)
			$TimerPuffy.stop()
			
		# On verifie si le poisson n'est plus vulnérable
		if $TimerVulnerable.is_stopped():
			startFollowPath = true
			$Sprite2D.self_modulate = Color.WHITE

# Méthode chargée de vérifier si le joueur se trouve au corps à corps du poisson.
func _on_range_attack_body_entered(body):
	# On vérifie si body est un joueur
	if body.is_in_group("player"):
		$TimerAttack.start() # On démarre le cooldown d'attaque
		# On vérifie que le nuage toxique et que la vulnerabilité du poisson ne sont pas actifs
		if $TimerReloadPoison.is_stopped() && $TimerVulnerable.is_stopped():
			# Instantiation du nuage toxique
			var cloudToxicInstance = cloudToxic.instantiate()
			cloudToxicInstance.position = position
			cloudToxicInstance.dmgPerSecPoison = dmgPerSecPoison
			cloudToxicInstance.timeAtkPerSecPoison = timeAtkPerSecPoison
			get_parent().add_child.call_deferred(cloudToxicInstance)
			# Dégonflement du poisson
			$AnimationPlayer.play_backwards("decreaseScale", -1)
			$TimerPuffy.stop()
			# On démarre le rechargement du nuage toxique
			$TimerReloadPoison.start()
		target = body
		body.takeDamage(damage) # Le joueur perds de l'oxygène

# Méthode chargée d'enlever de l'oxygène lorsque le cooldown de l'attaque est fini.
func _on_timer_attack_timeout():
	target.takeDamage(damage)

# Méthode chargée d'arrêter le cooldown de l'attaque quand il quitte la portée de son attaque.
func _on_range_attack_body_exited(body):
	if body.is_in_group("player"):
		$TimerAttack.stop()

# Méthode chargée s'assigner des actions quand l'AnimationPlayer fini l'une de ses animations.
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "decreaseScale" && !$TimerVulnerable.is_stopped() && $TimerPuffy.is_stopped():
		$Sprite2D.self_modulate = Color.GREEN
		
func _on_timer_puffy_timeout():
	$AnimationPlayer.play_backwards("decreaseScale", -1)
	$TimerVulnerable.start()

# Méthode chargée de gonffler le poisson lors de la fin du rechargement du nuage toxique 
# quand le joueur se trouve à portée de vue.
func _on_timer_reload_poison_timeout():
	if detect:
		$AnimationPlayer.play("increaseScale")

# Méthode chargée d'affecter la forme normal au poisson
# Si le joueur est detecté ALORS cela gonffle le poisson
# SINON le poisson reprends son chemin
func _on_timer_vulnerable_timeout():
	$Sprite2D.self_modulate = Color.WHITE
	if detect:
		$AnimationPlayer.play("increaseScale")
	else:
		startFollowPath = true

func isVulnerable():
	return !$TimerVulnerable.is_stopped()

func takeDamage(value):
	life -= value
	if life <= 0:
		dead()
		
func dead():
	queue_free()
