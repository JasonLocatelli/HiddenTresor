extends Control

#GAME STATE
enum GAME_STATE{NEW, LOAD, DELETE, NONE}
var gameState : GAME_STATE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameState = GAME_STATE.NONE
	if (SaveAndLoad.fileExist(1) or SaveAndLoad.fileExist(2) or SaveAndLoad.fileExist(3)) :
		$AspectRatioContainer/VBoxContainer/MarginContainer/MainMenu/LoadGame.disabled = false
	else :
		$AspectRatioContainer/VBoxContainer/MarginContainer/MainMenu/LoadGame.disabled = true

func _on_new_game_pressed() -> void:
	gameState = GAME_STATE.NEW
	$AspectRatioContainer/LoadMenu/Game1.disabled = false
	$AspectRatioContainer/LoadMenu/Game2.disabled = false
	$AspectRatioContainer/LoadMenu/Game3.disabled = false
	$AspectRatioContainer/LoadMenu/Delete.disabled = true
	$AspectRatioContainer/LoadMenu/Delete.visible = false
	$AspectRatioContainer/LoadMenu/StateGame.text = "CHOOSE FILE TO START A NEW GAME"
	$AspectRatioContainer/VBoxContainer/MarginContainer/MainMenu.visible = false
	$AspectRatioContainer/LoadMenu.visible = true

func _on_load_game_pressed() -> void:
	gameState = GAME_STATE.LOAD
	$AspectRatioContainer/LoadMenu/Game1.disabled = !SaveAndLoad.fileExist(1)
	$AspectRatioContainer/LoadMenu/Game2.disabled = !SaveAndLoad.fileExist(2)
	$AspectRatioContainer/LoadMenu/Game3.disabled = !SaveAndLoad.fileExist(3)
	$AspectRatioContainer/LoadMenu/Delete.disabled = false
	$AspectRatioContainer/LoadMenu/Delete.visible = true
	$AspectRatioContainer/LoadMenu/StateGame.text = "LOAD GAME"
	$AspectRatioContainer/VBoxContainer/MarginContainer/MainMenu.visible = false
	$AspectRatioContainer/LoadMenu.visible = true

func _on_return_pressed() -> void:
	if gameState == GAME_STATE.DELETE :
		gameState = GAME_STATE.LOAD
		$AspectRatioContainer/LoadMenu/StateGame.text = "LOAD GAME"
		$AspectRatioContainer/LoadMenu/Delete.visible = true
	else :
		gameState = GAME_STATE.NONE
		$AspectRatioContainer/VBoxContainer/MarginContainer/MainMenu.visible = true
		$AspectRatioContainer/LoadMenu.visible = false
		if (SaveAndLoad.fileExist(1) or SaveAndLoad.fileExist(2) or SaveAndLoad.fileExist(3)) :
			$AspectRatioContainer/VBoxContainer/MarginContainer/MainMenu/LoadGame.disabled = false
		else :
			$AspectRatioContainer/VBoxContainer/MarginContainer/MainMenu/LoadGame.disabled = true

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_game_1_pressed() -> void:
	GameManager.gameSlot = 1
	if gameState == GAME_STATE.LOAD :
		SaveAndLoad.loadDataFromSaveFile(GameManager.gameSlot)
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
	elif gameState == GAME_STATE.NEW:
		GameManager.resetElement()  
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
	elif gameState == GAME_STATE.DELETE:
		_onFileDeletion()

func _on_game_2_pressed() -> void:
	GameManager.gameSlot = 2
	if gameState == GAME_STATE.LOAD :
		SaveAndLoad.loadDataFromSaveFile(GameManager.gameSlot)
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
	elif gameState == GAME_STATE.NEW:
		GameManager.resetElement()  
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
	elif gameState == GAME_STATE.DELETE:
		_onFileDeletion()

func _on_game_3_pressed() -> void:
	GameManager.gameSlot = 3
	if gameState == GAME_STATE.LOAD :
		SaveAndLoad.loadDataFromSaveFile(GameManager.gameSlot)
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
	elif gameState == GAME_STATE.NEW:
		GameManager.resetElement()
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
	elif gameState == GAME_STATE.DELETE:
		_onFileDeletion()

func _on_delete_pressed() -> void:
	gameState = GAME_STATE.DELETE
	$AspectRatioContainer/LoadMenu/StateGame.text = "CHOOSE FILE TO DELETE SAVE FILE"
	$AspectRatioContainer/LoadMenu/Delete.visible = false
	$AspectRatioContainer/LoadMenu.visible = true

func _onFileDeletion() -> void:
	$AspectRatioContainer/LoadMenu.visible = false
	$AspectRatioContainer/comfirmation.visible = true

func _on_yes_pressed() -> void:
	SaveAndLoad.deleteDataFromSaveFile(GameManager.gameSlot)
	$AspectRatioContainer/comfirmation.visible = false
	if (SaveAndLoad.fileExist(1) or SaveAndLoad.fileExist(2) or SaveAndLoad.fileExist(3)) :
		$AspectRatioContainer/LoadMenu/Game1.disabled = !SaveAndLoad.fileExist(1)
		$AspectRatioContainer/LoadMenu/Game2.disabled = !SaveAndLoad.fileExist(2)
		$AspectRatioContainer/LoadMenu/Game3.disabled = !SaveAndLoad.fileExist(3)
		gameState = GAME_STATE.LOAD
		$AspectRatioContainer/LoadMenu/Delete.visible = true
		$AspectRatioContainer/LoadMenu.visible = true
		$AspectRatioContainer/LoadMenu/StateGame.text = "LOAD GAME"
	else :
		$AspectRatioContainer/VBoxContainer/MarginContainer/MainMenu/LoadGame.disabled = true
		$AspectRatioContainer/LoadMenu.visible = false
		$AspectRatioContainer/VBoxContainer/MarginContainer/MainMenu.visible = true

func _on_no_pressed() -> void:
	$AspectRatioContainer/comfirmation.visible = false
	$AspectRatioContainer/LoadMenu.visible = true
