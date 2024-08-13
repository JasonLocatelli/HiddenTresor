extends CharacterBody2D

# Vélocité de saut, définie comme une constante pour être utilisée lors de la détection du saut.
const JUMP_VELOCITY = -400.0
# Initialisation du temps d'oxygène restant appliqué à TimerOxygen
@export var initTimerOxygen = 30
# Vitesse maximale du personnage en pixels par seconde.
var max_speed = 225
# Force de gravité appliquée au personnage, récupérée depuis les paramètres du projet.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Valeur en temps reel de l'oxygène
var enableOxygen = false
# Si <code>true<code> alors il est en vie sinon mort
var isDead = false

func _ready():
	$TimerOxygen.wait_time = initTimerOxygen

# Fonction principale appelée à chaque frame, dédiée à la physique du jeu.
# 'delta' est le temps écoulé depuis la dernière frame, utilisé pour garantir des mouvements indépendants de la performance.
func _physics_process(delta):
	if !isDead:
		# Appliquer la gravité lorsque le personnage n'est pas au sol.
		if not is_on_floor():
			velocity.y += gravity * delta
			# Limiter la vitesse de chute pour éviter une accélération excessive en chute libre.
			velocity.y = clamp(velocity.y, -max_speed, max_speed)
		# Gérer le saut du personnage.
		# Si le personnage est au sol et que le joueur appuie sur la touche de saut, appliquer la vélocité de saut.
		if is_on_floor() and Input.is_action_pressed("jump"):
			velocity.y = JUMP_VELOCITY
		# Déterminer la direction horizontale en fonction des touches appuyées (droite ou gauche).
		# La fonction 'int()' convertit la valeur booléenne en entier (1 pour vrai, 0 pour faux).
		var x_dir = 0
		x_dir = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
		# Appliquer la vitesse horizontale en fonction de la direction détectée.
		# La vitesse est divisée par 1.5 pour un contrôle plus précis du personnage.
		velocity.x = x_dir * max_speed / 1.5

		# Appliquer le mouvement au personnage en utilisant la fonction 'move_and_slide()'.
		# Cette fonction gère automatiquement les collisions et permet au personnage de glisser le long des surfaces.
		move_and_slide()

# Méthode chargée de démarrer le timer d'oxygène.
func start_timer_oxygen():
	$TimerOxygen.start()
	enableOxygen = true

# Méthode chargée d'arrêter le timer d'oxygène.
func stop_timer_oxygen():
	$TimerOxygen.stop()
	enableOxygen = false

func dead():
	isDead = true
	GameManager.hud.displayGameOver()

func _on_timer_oxygen_timeout():
	dead()
