extends CanvasLayer
var game_is_playing = false

func _ready() -> void:
	%StartMenu.visible = true
	%GameOver.visible = false
	%MaxScoreLabel.text = "Max Score: " + str(Global.score_max)
	get_tree().paused = true
	%Music.play()
	if Global.music:
		%MusicToggle.button_pressed = true
	if Global.sfx:
		%SFXToggle.button_pressed = true
	
func _process(delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	%StartMenu.visible = false
	%GameOver.visible = false
	get_tree().paused = false
	game_is_playing = true


func _on_retry_pressed() -> void:
	%StartMenu.visible = false
	%GameOver.visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and game_is_playing:
		if Input.is_action_just_pressed("pause"):
			toggle_pause()

func toggle_pause() -> void:
	var new_state = not get_tree().paused
	get_tree().paused = new_state
	%GamePause.visible = new_state




func _on_music_toggled(toggled_on: bool) -> void:
	if toggled_on:
		# Se il CheckButton è selezionato, attiva l'audio del bus "Music"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
		print("Musica attivata")
		Global.music = true 
	else:
		# Se il CheckButton è deselezionato, disattiva l'audio del bus "Music"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
		print("Musica disattivata")
		Global.music = false


func _on_sfx_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		# Se il CheckButton è selezionato, attiva l'audio del bus "Music"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false)
		print("SFX attivata")
		Global.sfx = true 
	else:
		# Se il CheckButton è deselezionato, disattiva l'audio del bus "Music"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), true)
		print("SFX disattivata")
		Global.sfx = false


#func _on_back_pressed() -> void:
	#%Credits.visible = false
	#%GameMenu.visible = true
	

#
#func _on_b_credits_pressed() -> void:
	#%Credits.visible = true
	#%GameMenu.visible = false
