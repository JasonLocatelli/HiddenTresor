extends Control

#GAME STATE
enum GAME_STATE{NEW, LOAD, DELETE, NONE}
var gameState : GAME_STATE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameState = GAME_STATE.NONE
	if (SaveAndLoad.fileExist(1) or SaveAndLoad.fileExist(2) or SaveAndLoad.fileExist(3)) :
		$MainMenu/LoadGame.disabled = false
	else :
		$MainMenu/LoadGame.disabled = true

func _on_new_game_pressed() -> void:
	gameState = GAME_STATE.NEW
	$LoadMenu/Game1.disabled = false
	$LoadMenu/Game2.disabled = false
	$LoadMenu/Game3.disabled = false
	$LoadMenu/Delete.disabled = true
	$LoadMenu/Delete.visible = false
	$LoadMenu/StateGame.text = "CHOOSE FILE TO START A NEW GAME"
	$MainMenu.visible = false
	$LoadMenu.visible = true

func _on_load_game_pressed() -> void:
	gameState = GAME_STATE.LOAD
	$LoadMenu/Game1.disabled = !SaveAndLoad.fileExist(1)
	$LoadMenu/Game2.disabled = !SaveAndLoad.fileExist(2)
	$LoadMenu/Game3.disabled = !SaveAndLoad.fileExist(3)
	$LoadMenu/Delete.disabled = false
	$LoadMenu/Delete.visible = true
	$LoadMenu/StateGame.text = "LOAD GAME"
	$MainMenu.visible = false
	$LoadMenu.visible = true

func _on_return_pressed() -> void:
	if gameState == GAME_STATE.DELETE :
		gameState = GAME_STATE.LOAD
		$LoadMenu/StateGame.text = "LOAD GAME"
		$LoadMenu/Delete.visible = true
	else :
		gameState = GAME_STATE.NONE
		$MainMenu.visible = true
		$LoadMenu.visible = false
		if (SaveAndLoad.fileExist(1) or SaveAndLoad.fileExist(2) or SaveAndLoad.fileExist(3)) :
			$MainMenu/LoadGame.disabled = false
		else :
			$MainMenu/LoadGame.disabled = true

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
	$LoadMenu/StateGame.text = "CHOOSE FILE TO DELETE SAVE FILE"
	$LoadMenu/Delete.visible = false
	$LoadMenu.visible = true

func _onFileDeletion() -> void:
	$LoadMenu.visible = false
	$comfirmation.visible = true

func _on_yes_pressed() -> void:
	SaveAndLoad.deleteDataFromSaveFile(GameManager.gameSlot)
	$comfirmation.visible = false
	if (SaveAndLoad.fileExist(1) or SaveAndLoad.fileExist(2) or SaveAndLoad.fileExist(3)) :
		$LoadMenu/Game1.disabled = !SaveAndLoad.fileExist(1)
		$LoadMenu/Game2.disabled = !SaveAndLoad.fileExist(2)
		$LoadMenu/Game3.disabled = !SaveAndLoad.fileExist(3)
		gameState = GAME_STATE.LOAD
		$LoadMenu/Delete.visible = true
		$LoadMenu.visible = true
		$LoadMenu/StateGame.text = "LOAD GAME"
	else :
		$MainMenu/LoadGame.disabled = true
		$LoadMenu.visible = false
		$MainMenu.visible = true

func _on_no_pressed() -> void:
	$comfirmation.visible = false
	$LoadMenu.visible = true
