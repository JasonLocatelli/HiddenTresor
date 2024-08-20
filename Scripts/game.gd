extends Node2D
var blockStart
var blockPassBoss1
func _ready():
	GameManager.find_nodes()
	AudioManager.audioSplash = $TriggerWaterZone/AudioSplash
	GameManager.posEntranceBoss1 = $EntranceBoss1
	AudioServer.set_bus_effect_enabled(AudioManager.SFX_BUS_ID, 0, false)
	AudioManager.setVolumeAudioProcedural(0)
	AudioManager.play_music_outwater()
	AudioManager.play_ambient_outdoor()
	AudioManager.stopMusicGameOver()
	AudioManager.stopMusicMainMenu()

# Méthode chargée d'activer le bloquage du passage par les oursins.
func _on_trigger_start_body_entered(body):
	if body.is_in_group("player") && !blockStart:
		$Ennemies/Urchin.startFollowPath = true
		$Ennemies/Urchin2.startFollowPath = true
		$Triggers/TriggerStart/StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
		blockStart = true

# Méthode chargée de detecter si le joueur est dans l'eau.
func _on_trigger_water_zone_body_entered(body):
	if body.is_in_group("player"):
		AudioManager.music_underwater()

# Méthode chargée de jouer un "Impact" quand les oursins ont finis de bloquer le passage.
func _on_trigger_impact_start_body_entered(body):
	if body.is_in_group("enemy"):
		$Triggers/TriggerImpactStart/AudioImpact.play()


func _on_trigger_boss_1_body_entered(body):
	if body.is_in_group("player") && !blockPassBoss1:
		$Ennemies/Urchin3.startFollowPath = true
		$Ennemies/Urchin4.startFollowPath = true
		$Triggers/TriggerBoss1/StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
		$Boss1/Spikodon.enableSpikodon()
		blockPassBoss1 = true

func _on_trigger_impact_boss_1_body_entered(body):
	if body.is_in_group("enemy"):
		$Triggers/TriggerImpactBoss1/AudioImpact.play()
