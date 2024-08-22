extends Control

#GAME STATE
enum GAME_STATE{NEW, LOAD, NONE}
var gameState : GAME_STATE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"%NewGame".grab_focus()
	gameState = GAME_STATE.NONE
	AudioManager.stopMusicInGame()
	AudioManager.playMusicMainMenu()
	if (SaveAndLoad.fileExist(1) or SaveAndLoad.fileExist(2) or SaveAndLoad.fileExist(3)) :
		%LoadGame.disabled = false
		$"%LoadGame".focus_mode = FocusMode.FOCUS_ALL
	else :
		%LoadGame.disabled = true
		$"%LoadGame".focus_mode = FocusMode.FOCUS_NONE
	
func _on_new_game_pressed() -> void:
	gameState = GAME_STATE.NEW
	AudioManager.playAudioSelect()
	$AspectRatioContainer/LoadMenu/HBoxContainer/Game1.grab_focus()
	$AspectRatioContainer/LoadMenu/HBoxContainer/Game1.disabled = false
	$AspectRatioContainer/LoadMenu/HBoxContainer2/Game2.disabled = false
	$AspectRatioContainer/LoadMenu/HBoxContainer3/Game3.disabled = false
	$AspectRatioContainer/LoadMenu/HBoxContainer/deleteSave1.visible = false
	$AspectRatioContainer/LoadMenu/HBoxContainer2/deleteSave2.visible = false
	$AspectRatioContainer/LoadMenu/HBoxContainer3/deleteSave3.visible = false
	$AspectRatioContainer/LoadMenu/StateGame.text = "CHOOSE FILE TO START A NEW GAME"
	$AspectRatioContainer/VBoxContainer/MarginContainer/MainMenu.visible = false
	$AspectRatioContainer/LoadMenu.visible = true

func _on_load_game_pressed() -> void:
	gameState = GAME_STATE.LOAD
	AudioManager.playAudioSelect()
	$AspectRatioContainer/LoadMenu/HBoxContainer/Game1.grab_focus()
	$AspectRatioContainer/LoadMenu/HBoxContainer/Game1.disabled = !SaveAndLoad.fileExist(1)
	$AspectRatioContainer/LoadMenu/HBoxContainer2/Game2.disabled = !SaveAndLoad.fileExist(2)
	$AspectRatioContainer/LoadMenu/HBoxContainer3/Game3.disabled = !SaveAndLoad.fileExist(3)
	$AspectRatioContainer/LoadMenu/HBoxContainer/deleteSave1.disabled = !SaveAndLoad.fileExist(1)
	$AspectRatioContainer/LoadMenu/HBoxContainer2/deleteSave2.disabled = !SaveAndLoad.fileExist(2)
	$AspectRatioContainer/LoadMenu/HBoxContainer3/deleteSave3.disabled = !SaveAndLoad.fileExist(3)
	$AspectRatioContainer/LoadMenu/HBoxContainer/deleteSave1.visible = true
	$AspectRatioContainer/LoadMenu/HBoxContainer2/deleteSave2.visible = true
	$AspectRatioContainer/LoadMenu/HBoxContainer3/deleteSave3.visible = true
	$AspectRatioContainer/LoadMenu/StateGame.text = "LOAD GAME"
	$AspectRatioContainer/VBoxContainer/MarginContainer/MainMenu.visible = false
	$AspectRatioContainer/LoadMenu.visible = true

func _on_return_pressed() -> void:
	gameState = GAME_STATE.NONE
	$"%NewGame".grab_focus()
	AudioManager.playAudioSelect()
	$AspectRatioContainer/VBoxContainer/MarginContainer/MainMenu.visible = true
	$AspectRatioContainer/LoadMenu.visible = false
	if (SaveAndLoad.fileExist(1) or SaveAndLoad.fileExist(2) or SaveAndLoad.fileExist(3)) :
		%LoadGame.disabled = false
	else :
		%LoadGame.disabled = true
	
func _on_exit_pressed() -> void:
	AudioManager.playAudioSelect()
	get_tree().quit()

func _on_game_1_pressed() -> void:
	GameManager.gameSlot = 1
	AudioManager.playAudioSelect()
	if gameState == GAME_STATE.LOAD :
		SaveAndLoad.loadDataFromSaveFile(GameManager.gameSlot)
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
	elif gameState == GAME_STATE.NEW:
		GameManager.resetElement()  
		get_tree().change_scene_to_file("res://Scenes/introScene.tscn")

func _on_game_2_pressed() -> void:
	GameManager.gameSlot = 2
	AudioManager.playAudioSelect()
	if gameState == GAME_STATE.LOAD :
		SaveAndLoad.loadDataFromSaveFile(GameManager.gameSlot)
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
	elif gameState == GAME_STATE.NEW:
		GameManager.resetElement()  
		get_tree().change_scene_to_file("res://Scenes/introScene.tscn")

func _on_game_3_pressed() -> void:
	GameManager.gameSlot = 3
	AudioManager.playAudioSelect()
	if gameState == GAME_STATE.LOAD :
		SaveAndLoad.loadDataFromSaveFile(GameManager.gameSlot)
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
	elif gameState == GAME_STATE.NEW:
		GameManager.resetElement()
		get_tree().change_scene_to_file("res://Scenes/introScene.tscn")


func _onFileDeletion() -> void:
	$AspectRatioContainer/comfirmation/FileNumber.text = "File "+str(GameManager.gameSlot)
	$AspectRatioContainer/LoadMenu.visible = false
	$AspectRatioContainer/comfirmation.visible = true
	

func _on_yes_pressed() -> void:
	SaveAndLoad.deleteDataFromSaveFile(GameManager.gameSlot)
	AudioManager.playAudioSelect()
	$AspectRatioContainer/comfirmation.visible = false
	if (SaveAndLoad.fileExist(1) or SaveAndLoad.fileExist(2) or SaveAndLoad.fileExist(3)) :
		$AspectRatioContainer/LoadMenu/HBoxContainer/Game1.disabled = !SaveAndLoad.fileExist(1)
		$AspectRatioContainer/LoadMenu/HBoxContainer2/Game2.disabled = !SaveAndLoad.fileExist(2)
		$AspectRatioContainer/LoadMenu/HBoxContainer3/Game3.disabled = !SaveAndLoad.fileExist(3)
		$AspectRatioContainer/LoadMenu/HBoxContainer/deleteSave1.disabled = !SaveAndLoad.fileExist(1)
		$AspectRatioContainer/LoadMenu/HBoxContainer2/deleteSave2.disabled = !SaveAndLoad.fileExist(2)
		$AspectRatioContainer/LoadMenu/HBoxContainer3/deleteSave3.disabled = !SaveAndLoad.fileExist(3)
		gameState = GAME_STATE.LOAD
		$AspectRatioContainer/LoadMenu.visible = true
	else :
		$"%LoadGame".focus_mode = FocusMode.FOCUS_NONE
		%LoadGame.disabled = true
		$AspectRatioContainer/LoadMenu.visible = false
		$AspectRatioContainer/VBoxContainer/MarginContainer/MainMenu.visible = true
	
func _on_no_pressed() -> void:
	$AspectRatioContainer/comfirmation.visible = false
	$AspectRatioContainer/LoadMenu.visible = true
	AudioManager.playAudioSelect()

func _on_delete_save_1_pressed() -> void:
	GameManager.gameSlot = 1
	AudioManager.playAudioSelect()
	_onFileDeletion()

func _on_delete_save_2_pressed() -> void:
	GameManager.gameSlot = 2
	AudioManager.playAudioSelect()
	_onFileDeletion()

func _on_delete_save_3_pressed() -> void:
	GameManager.gameSlot = 3
	AudioManager.playAudioSelect()
	_onFileDeletion()

func _on_return_menu_pressed() -> void:
	$"%Credits".grab_focus()
	$AspectRatioContainer/VBoxContainer/MarginContainer/MainMenu.visible = true
	$AspectRatioContainer/Credit.visible = false


func _on_credits_pressed() -> void:
	$AspectRatioContainer/Credit/ReturnMenu.grab_focus()
	$AspectRatioContainer/VBoxContainer/MarginContainer/MainMenu.visible = false
	$AspectRatioContainer/Credit.visible = true
	AudioManager.playAudioSelect()
