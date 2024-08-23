extends Control

@export var loadingBar : ProgressBar
@export var lbPercentage : Label
var scenePath
var progress : Array
var update : float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scenePath = "res://Scenes/game.tscn"
	ResourceLoader.load_threaded_request(scenePath)
	$Button.grab_focus()
	$AnimationPlayer.play("scrolling")

func _process(delta):
	ResourceLoader.load_threaded_get_status(scenePath, progress)
	if progress[0] > update:
		update = progress[0]
			
	if loadingBar.value >= 1 && update >= 1:
		$Button.visible = true
		
	if loadingBar.value < update:
		loadingBar.value = lerp(loadingBar.value, update, delta)
	loadingBar.value += delta * 0.2 * (0.5 if update >= 1.0 else clamp(0.9 - loadingBar.value, 0.0, 1.0))
	lbPercentage.text = str(int(loadingBar.value * 100.0)) + " %"

		
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if $Button.visible:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scenePath))

func _on_button_pressed() -> void:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scenePath))
