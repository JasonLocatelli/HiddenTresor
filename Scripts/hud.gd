extends Control
class_name HUD

var progressbarOxygen : ProgressBar
var animGameOver : AnimationPlayer

@onready var itemOptions = preload("res://Scenes/power_up_panel.tscn")

func _ready():
	progressbarOxygen = $PbOxygen
	animGameOver = $GameOver/AnimationPlayer
	update_coins_quantity()
	fillStore()

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
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func update_coins_quantity():
	$MarginContainer/HBoxContainer/numberOfCoins.text = str(GameManager.coins)
	resetAllButtonActivation()
func set_visible_pb_oxygen(value : bool):
	progressbarOxygen.visible = value

func storeVisibility(visibleChange):
	$store.visible = visibleChange
	
func fillStore():
	print("Filling the store...")
	for key in PowerDb.UPGRADE :
		print("Adding item:", key)
		var powerUp = PowerDb.UPGRADE[key]
		var option_choice = itemOptions.instantiate()
		option_choice.item = powerUp
		option_choice.initElement()
		$store/MarginContainer/VBoxContainer.add_child(option_choice)
		
func resetAllButtonActivation():
	for element in $store/MarginContainer/VBoxContainer.get_children() :
		if element is PanelContainer :
			element.updateButton()
