extends Node

var loadingScreen = load("res://Scenes/LoadingScreen.tscn")
var scenePath : String 

func change_level(path):
	scenePath = path
	get_tree().change_scene_to_packed(loadingScreen)
