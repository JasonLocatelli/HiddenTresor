extends Control
class_name HUD

var progressbarOxygen : TextureProgressBar
var animGameOver : AnimationPlayer

@onready var itemOptions = preload("res://Scenes/power_up_panel.tscn")

func _ready():
	progressbarOxygen = $VBoxContainer/MarginContainer/HBoxContainer/PbOxygen
	animGameOver = $GameOver/AnimationPlayer
	update_coins_quantity()
	fillStore()

# Met a jour la valeur de l'oxygene 
func updateValuePbOxygen(value):
	if value == 0 && !GameManager.player.isDead:
		progressbarOxygen.value = progressbarOxygen.max_value
	elif value == 0 && GameManager.player.isDead:
		progressbarOxygen.value = value
	else:
		progressbarOxygen.value = value
		
# Met a jour la valeur max de l'oxygene
func updateMaxValuePbOxygen(value : float):
	progressbarOxygen.max_value = value
	
# Méthode chargée d'activer l'animation pour afficher le game over.
func displayGameOver():
	animGameOver.play("displayGameOver")
	$GameOver/Panel/MarginContainer/VboxBtn/BtnRestart.grab_focus()
	AudioManager.stopMusicInGame()
	AudioManager.playGameOver()

# Méthode chargée s'assigner un evènement au bouton "Restart".
func _on_btn_restart_pressed():
	AudioManager.playAudioSelect()
	get_tree().reload_current_scene()

# Méthode chargée d'assigner un evènement au bouton "Quit".
func _on_btn_quit_pressed():
	AudioManager.playAudioSelect()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func update_coins_quantity():
	%numberOfCoins.text = str(GameManager.coins)
	resetAllButtonActivation()

func set_visible_pb_oxygen(value : bool):
	progressbarOxygen.visible = value

func storeVisibility(visibleChange):
	$store.visible = visibleChange
	if visibleChange:
		$store/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.get_child(0).button.grab_focus()
	
func fillStore():
	for key in PowerDb.UPGRADE :
		var powerUp = PowerDb.UPGRADE[key]
		var option_choice = itemOptions.instantiate()
		option_choice.item = powerUp
		option_choice.initElement()
		$store/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.add_child(option_choice)
		
	$store/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.get_child(0).button.grab_focus()
func resetAllButtonActivation():
	for element in $store/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.get_children() :
		if element is PanelContainer :
			element.updateButton()
