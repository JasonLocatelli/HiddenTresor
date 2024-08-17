extends Node2D
var blockStart

func _ready():
	GameManager.find_nodes()
	AudioManager.audioSplash = $AudioSplash
	AudioServer.set_bus_effect_enabled(AudioManager.SFX_BUS_ID, 0, false)
	AudioManager.play_music_outwater()
	AudioManager.play_ambient_outdoor()
	
# Méthode chargée d'activer le bloquage du passage par les oursins.
func _on_trigger_start_body_entered(body):
	if body.is_in_group("player") && !blockStart:
		$Ennemies/Urchin.startFollowPath = true
		$Ennemies/Urchin2.startFollowPath = true
		blockStart = true

# Méthode chargée de detecter si le joueur est dans l'eau.
func _on_trigger_water_zone_body_entered(body):
	if body.is_in_group("player"):
		AudioManager.music_underwater()

# Méthode chargée de jouer un "Impact" quand les oursins ont finis de bloquer le passage.
func _on_trigger_impact_start_body_entered(body):
	if body.is_in_group("enemy"):
		$Triggers/TriggerImpactStart/AudioImpact.play()
