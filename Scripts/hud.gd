extends Control
class_name HUD

var progressbarOxygen : ProgressBar
var animGameOver : AnimationPlayer

func _ready():
	progressbarOxygen = $PbOxygen
	animGameOver = $GameOver/AnimationPlayer

func updateValuePbOxygen(value):
	progressbarOxygen.value = value

func updateMaxValuePbOxygen(value : float):
	progressbarOxygen.max_value = value
	
# Méthode chargée d'activer l'animation pour afficher le game over.
func displayGameOver():
	animGameOver.play("displayGameOver")

# Méthode chargée s'assigner un evènement au bouton "Restart".
func _on_btn_restart_pressed():
	GameManager.load_game_scene()

# Méthode chargée d'assigner un evènement au bouton "Quit".
func _on_btn_quit_pressed():
	print("Display main menu")
