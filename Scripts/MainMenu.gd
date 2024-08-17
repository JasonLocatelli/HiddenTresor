extends Control

#GAME STATE
enum GAME_STATE{NEW, LOAD, NONE}
var gameState : GAME_STATE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameState = GAME_STATE.NONE

func _on_new_game_pressed() -> void:
	gameState = GAME_STATE.NEW
	$LoadMenu/StateGame.text = "CHOOSE FILE TO NEW GAME"
	$MainMenu.visible = false
	$LoadMenu.visible = true

func _on_load_game_pressed() -> void:
	gameState = GAME_STATE.LOAD
	$LoadMenu/StateGame.text = "LOAD GAME"
	$MainMenu.visible = false
	$LoadMenu.visible = true

func _on_return_pressed() -> void:
	gameState = GAME_STATE.NONE
	$MainMenu.visible = true
	$LoadMenu.visible = false

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_game_1_pressed() -> void:
	if gameState == GAME_STATE.LOAD :
		pass
	elif gameState == GAME_STATE.NEW:
		GameManager.resetElement()  
		get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_game_2_pressed() -> void:
	if gameState == GAME_STATE.LOAD :
		pass
	elif gameState == GAME_STATE.NEW:
		GameManager.resetElement()  
		get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_game_3_pressed() -> void:
	if gameState == GAME_STATE.LOAD :
		pass
	elif gameState == GAME_STATE.NEW:
		GameManager.resetElement() 
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
