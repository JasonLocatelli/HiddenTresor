extends CharacterBody2D

var detect
var target
var isVulnerable
var animReverse
@export var initLife = 40 # Vie du poisson

var life = 40 # Vie du poisson
@export var damage = 4 # Dommage du poisson
@export var timeAttack = 1 # Cooldown de l'attaque du poisson
@export var dmgPerSecPoison = 1 # Dommage par secondes
@export var timeAtkPerSecPoison = 1 # Cooldown des dmg du poison
@export var timeReloadPoison = 4 # Cooldown du rechargement du poisson
@export var timeVulnerable = 3 # Cooldown de la vulnérabilité

@onready var cloudToxic = load("res://Scenes/cloud_toxic.tscn")
@onready var main = get_tree().get_root().get_node("Game")
@onready var projectile = load("res://Scenes/Spike.tscn")

@onready var spikeNormal = load("res://Sprites/Boss1/spike1.png")
@onready var spikeOrange = load("res://Sprites/Boss1/spike2.png")

func _ready():
	life = initLife
	$TimerAttack.wait_time = timeAttack

func startTimerMakeAttackPoison():
	var rngTime = randi_range(3,12)
	$TimerMakeAttackPoison.start(rngTime)
	
# Méthode chargée de vérifier si le joueur se trouve en dehors de la portée de vue du poisson.
func _on_range_detect_body_exited(body):
	# On vérifie si body est un joueur
	if body.is_in_group("player"):
		detect = false
		$TimerMakeAttackPoison.stop()
		$TimerWaitToMove.start() # On marque un temps d'arrêter au poisson
# Méthode chargée d'enlever de l'oxygène lorsque le cooldown de l'attaque est fini.
func _on_timer_attack_timeout():
	target.takeDamage(damage)

func _on_range_attack_body_entered(body):
	if body.is_in_group("player"):
		target = body
		$TimerAttack.start()

# Méthode chargée d'arrêter le cooldown de l'attaque quand il quitte la portée de son attaque.
func _on_range_attack_body_exited(body):
	if body.is_in_group("player"):
		$TimerAttack.stop()

# Méthode chargée de gonffler le poisson lors de la fin du rechargement du nuage toxique 
# quand le joueur se trouve à portée de vue.
func _on_timer_reload_poison_timeout():
	if detect:
		$AnimationPlayer.play("increaseScale")
		startTimerMakeAttackPoison()

# Méthode chargée d'affecter la forme normal au poisson
# Si le joueur est detecté ALORS cela gonffle le poisson
# SINON le poisson reprends son chemin
func _on_timer_vulnerable_timeout():
	$Sprite2D.self_modulate = Color.WHITE
	if detect:
		$AnimationPlayer.play("increaseScale")
		
func takeDamage(value):
	print("Life ",life)
	if isVulnerable:
		life -= value
		if life <= 0:
			dead()
		AudioManager.playAudioSlash()
	else:
		AudioManager.playAudioHit()
	print(initLife/2.0)
	if life <= (initLife/2.0):
		AudioManager.editPitchAudioMusicBoss1(1.1)
		
	makeGas()

func dead():
	AudioManager.playAudioWin()
	AudioManager.playMusicProcedural()
	AudioManager.audioBoss1ToUnderwater()
	GameManager.deleteDoorBoss1()
	queue_free()

func makeGas():
	# Instantiation du nuage toxique
	var cloudToxicInstance = cloudToxic.instantiate()
	cloudToxicInstance.position = position
	cloudToxicInstance.dmgPerSecPoison = dmgPerSecPoison
	cloudToxicInstance.timeAtkPerSecPoison = timeAtkPerSecPoison
	get_parent().add_child.call_deferred(cloudToxicInstance)
	
func startVulnerable():
	isVulnerable = true
	$AnimatedSprite2D.self_modulate = Color.PALE_TURQUOISE
func stopVulnerable():
	isVulnerable = false
	$AnimatedSprite2D.self_modulate = Color.WHITE
	
func _on_make_attack_poison_timeout():
	makeGas()

func enableSpikodon():
	$BTPlayer.active = true
	AudioManager.audioUnderwaterToBoss1()

func makeExplosionSpike():
	$AnimatedSprite2D.play("default")
	animReverse = false
	var direction = 0
	for i in range(12):
		var instance = projectile.instantiate()
		if i >= 6:
			instance.texture = spikeOrange
			
		instance.dir = direction
		instance.spawnPos = global_position
		instance.spawnRot = direction
		direction += 22.5
		main.add_child.call_deferred(instance)


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "default" && !animReverse:
		$AnimatedSprite2D.play("default", -1.0,true)
		animReverse = true


func _on_visible_on_screen_notifier_2d_screen_entered():
	visible = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	visible = false
