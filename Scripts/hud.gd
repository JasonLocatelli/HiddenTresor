extends Control
class_name HUD

var progressbarOxygen : ProgressBar

func _ready():
	progressbarOxygen = $PbOxygen

func _process(delta):
	pass

func updateValuePbOxygen(value):
	progressbarOxygen.value = value

func updateMaxValuePbOxygen(value : float):
	progressbarOxygen.max_value = value
	
