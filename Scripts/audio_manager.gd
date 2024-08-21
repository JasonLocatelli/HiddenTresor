extends Node2D

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")

var audioSplash : AudioStreamPlayer2D
var tween

# Tableau avec les références de différentes voix de saut
var sourceJumpVoice = ["res://SFX/Sounds/609789-volvion-man-jumping-noises_1.mp3", "res://SFX/Sounds/609789-volvion-man-jumping-noises_2.mp3"
, "res://SFX/Sounds/609789-volvion-man-jumping-noises_3.mp3", "res://SFX/Sounds/609789-volvion-man-jumping-noises_4.mp3"]

# Tableau avec les références de différentes voix de souffrance
var sourceHurtVoice = ["res://SFX/Sounds/609784-volvion-man-hurt-noises_1.mp3","res://SFX/Sounds/609784-volvion-man-hurt-noises_2.mp3", 
"res://SFX/Sounds/609784-volvion-man-hurt-noises_3.mp3", "res://SFX/Sounds/609784-volvion-man-hurt-noises_4.mp3"]

# Tableau avec les références de différentes voix de souffrance
var sourceDrowningVoice = ["res://SFX/Sounds/488957-muses212-drowning-man_1.mp3", "res://SFX/Sounds/488957-muses212-drowning-man_2.mp3",
"res://SFX/Sounds/488957-muses212-drowning-man_3.mp3"]

# Méthode chargée de jouer la musique sous l'eau
func play_music_outwater():
	$AudioMusicProcedural.stream.set_sync_stream_volume(0, -10)
	$AudioMusicProcedural.stream.set_sync_stream_volume(1, -40)
	$AudioMusicProcedural.play()
	music_outwater()
	
# Méthode chargée de jouer l'ensemble des musiques qui sert au procédural.
func playMusicProcedural():
	$AudioMusicProcedural.play()
	
# Méthode chargée de faire la transition vers la musique sous l'eau
func music_underwater():
	# On enlève les anciens "Tween"
	cleanTween() 
	tween = get_tree().create_tween()
	tween.tween_property($AudioMusicProcedural.stream, "stream_0/volume", -40, 3)
	tween.set_parallel().tween_property($AudioMusicProcedural.stream, "stream_1/volume", 0, 3)
	$AudioAmbientOutdoor.stop()
	# Activation de l'effet "sous l'eau"
	AudioServer.set_bus_effect_enabled(AudioManager.SFX_BUS_ID, 0, true)
	$AmbientUnderWater.play()
	
# Méthode chargée de faire la transition vers la musique hors de l'eau
func music_outwater():
	# On enlève les anciens "Tween"
	cleanTween() 
	tween = get_tree().create_tween()
	tween.tween_property($AudioMusicProcedural.stream, "stream_0/volume", -10, 0.5)
	tween.set_parallel().tween_property($AudioMusicProcedural.stream, "stream_1/volume", -40, 1.5)
	$AmbientUnderWater.stream_paused = true
	$AudioMusicProcedural.stream.set_sync_stream_volume(2, -60)
	
# Méthode chargée de faire la transition de la musique en dehors de l'eau vers la musique de la boutique.
func music_outwater_to_shop():
	# On enlève les anciens "Tween"
	cleanTween() 
	tween = get_tree().create_tween()
	tween.tween_property($AudioMusicProcedural.stream, "stream_0/volume", -40, 1.5)
	tween.set_parallel().tween_property($AudioMusicProcedural.stream, "stream_2/volume", -10, 0.5)

# Méthode chargée de faire la transition de la musique de la boutique vers la musique en dehors de l'eau.
func music_shop_to_outwater():
	# On enlève les anciens "Tween"
	cleanTween() 
	tween = get_tree().create_tween()
	tween.tween_property($AudioMusicProcedural.stream, "stream_0/volume", -10, 0.5)
	tween.set_parallel().tween_property($AudioMusicProcedural.stream, "stream_2/volume", -40, 1.5)

# Méthode chargée de jouer le sons du personnage qui saute.
func play_human_jump():
	sourceJumpVoice.shuffle()
	var audioStream = load(sourceJumpVoice[randi_range(0,sourceJumpVoice.size()-1)])
	$AudioVoice.set_stream(audioStream)
	$AudioVoice.play()

# Méthode chargée de jouer le sons du personnage souffre.
func play_human_hurt():
	sourceHurtVoice.shuffle()
	var audioStream = load(sourceHurtVoice[randi_range(0,sourceHurtVoice.size()-1)])
	$AudioVoice.set_stream(audioStream)
	$AudioVoice.play()
	
# Méthode chargée de jouer le sons du personnage qui se noye
func play_human_drowning():
	sourceDrowningVoice.shuffle()
	var audioStream = load(sourceDrowningVoice[randi_range(0,sourceDrowningVoice.size()-1)])
	$AudioVoice.set_stream(audioStream)
	$AudioVoice.play()

# Méthode chargée de jouer le son d'ambiance en dehors de l'eau.
func play_ambient_outdoor():
	$AudioAmbientOutdoor.play()
	
# Méthode chargée de jouer le sons ambiance sous l'eau.
func play_ambient_underwater():
	$AmbientUnderWater.play()

# Méthode chargée d'arrêter le sons ambiance sous l'eau.
func stop_ambient_underwater():
	$AmbientUnderWater.stop()

# Méthode chargée de jouer le sons d'un plongeon.
func play_audio_splash():
	audioSplash.play()

# Méthode chargée de jouer le sons d'un ramassage de pièce.
func play_pick_up_coin():
	$AudioPickUpCoin.play()

# Méthode chargée d'enlever les anciens "Tween".
func cleanTween():
	if tween:
		tween.kill()

# Méthode chargée de jouer la musique du game over.
func playGameOver():
	$AudioGameOver.play()
	
# Méthode chargée d'arrêter la musique du game over.
func stopMusicGameOver():
	$AudioGameOver.stop()
	
# Méthode chargée d'arrêter les musiques qui sont trouve dans la partie.
func stopMusicInGame():
	$AmbientUnderWater.stop()
	$AudioMusicProcedural.stop()
	$AudioGameOver.stop()
	$AudioMusicBoss1.stop()
	
# Méthode chargée de reinitialiser les musiques comme à leurs première apparition:
func resetAudios():
	setVolumeAudioProcedural(0)
	AudioServer.set_bus_effect_enabled(AudioManager.SFX_BUS_ID, 0, false)
	editPitchAudioMusicBoss1(1)
	
# Méthode chargée d'arrêter la musique procédural.
func stopMusicProcedural():
	$AudioMusicProcedural.stop()

# Méthode chargée de jouer la musique du menu principal.
func playMusicMainMenu():
	$AudioMainMenu.play()

# Méthode chargée d'arrêter la musique du menu principal.
func stopMusicMainMenu():
	$AudioMainMenu.stop()
	
# Méthode chargée de jouer l'audio de selection.
func playAudioSelect():
	$AudioSelect.play()

# Méthode chargée de jouer l'audio quand l'attaque du joueur est un succès.
func playAudioSlash():
	$AudioSlash.play()
	
# Méthode chargée de jouer l'audio quand l'attaque du joueur touche l'ennemi n'est ne fait pas de dégats.
func playAudioHit():
	$AudioHit.play()

func playAudioSwim():
	$AudioSwim.play()

func stopAudioSwim():
	$AudioSwim.play()

func stopAudioBoss1():
	$AudioMusicBoss1.stop()

func audioUnderwaterToBoss1():
	# On enlève les anciens "Tween"
	cleanTween() 
	tween = get_tree().create_tween()
	tween.tween_property($AudioMusicProcedural, "volume_db", -40, 2)
	tween.set_parallel().tween_property($AudioMusicBoss1, "volume_db", -10, 4).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(AudioManager.stopMusicProcedural).set_delay(4)
	$AudioMusicBoss1.play()
	
func audioBoss1ToUnderwater():
	# On enlève les anciens "Tween"
	cleanTween() 
	tween = get_tree().create_tween()
	tween.tween_property($AudioMusicProcedural, "volume_db", -10, 5)
	tween.set_parallel().tween_property($AudioMusicBoss1, "volume_db", -40, 2).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(stopAudioBoss1)

# Méthode chargée de changer le pitch de la musique du premier boss.
func editPitchAudioMusicBoss1(value):
	$AudioMusicBoss1.pitch_scale = value

func setVolumeAudioProcedural(value):
	$AudioMusicProcedural.volume_db = value

func playAudioWin():
	$AudioWin.play()
