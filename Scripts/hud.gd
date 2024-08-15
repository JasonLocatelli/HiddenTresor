extends Control
class_name HUD

var progressbarOxygen : ProgressBar
var animGameOver : AnimationPlayer

func _ready():
	progressbarOxygen = $PbOxygen
	animGameOver = $GameOver/AnimationPlayer
	update_coins_quantity()

# Met a jour la valeur de l'oxygene
func updateValuePbOxygen(value):
	progressbarOxygen.value = value

# Met a jour la valeur max de l'oxygene
func updateMaxValuePbOxygen(value : float):
	progressbarOxygen.max_value = value
	
# Méthode chargée d'activer l'animation pour afficher le game over.
func displayGameOver():
	animGameOver.play("displayGameOver")
	set_visible_pb_oxygen(false)

# Méthode chargée s'assigner un evènement au bouton "Restart".
func _on_btn_restart_pressed():
	get_tree().reload_current_scene()

# Méthode chargée d'assigner un evènement au bouton "Quit".
func _on_btn_quit_pressed():
	print("Display main menu")

func update_coins_quantity():
	$numberOfCoins.text = str(GameManager.coins)
	
func set_visible_pb_oxygen(value : bool):
	progressbarOxygen.visible = value

func storeVisibility(visible):
	$store.visible = visible
