extends CanvasLayer
var game_is_playing = false

func _ready() -> void:
	%StartMenu.visible = true
	%GameOver.visible = false
	%GamePause.visible = false
	%HelpMenu.visible = false
	%GlobalScores.visible = false
	%MaxScoreLabel.text = "Max Score: " + str(Global.score_max)
	get_tree().paused = true
	%Music.play()
	if Global.music:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
		%MusicToggle.button_pressed = true
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
		%MusicToggle.button_pressed = false
	if Global.sfx:
		%SFXToggle.button_pressed = true
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false)
	else:
		%SFXToggle.button_pressed = false
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), true)
	
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
		if Input.is_action_just_pressed("Pause"):
			toggle_pause()
		if Input.is_action_just_pressed("Restart"):
			get_tree().paused = false
			get_tree().reload_current_scene()

func toggle_pause() -> void:
	var new_state = not get_tree().paused
	get_tree().paused = new_state
	%GamePause.visible = new_state




func _on_music_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
		print("Musica attivata")
		Global.music = true 
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
		print("Musica disattivata")
		Global.music = false


func _on_sfx_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false)
		print("SFX attivata")
		Global.sfx = true 
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), true)
		print("SFX disattivata")
		Global.sfx = false


func _on_return_pause_pressed() -> void:
	toggle_pause()


func _on_help_button_pressed() -> void:
	%HelpMenu.visible = true
	%StartMenu.visible = false

func _on_back_from_help_pressed() -> void:
	%HelpMenu.visible = false
	%StartMenu.visible = true


func _on_back_from_global_scores_pressed() -> void:
	%StartMenu.visible = true
	%GlobalScores.visible = false

func _on_global_scores_pressed() -> void:
	%StartMenu.visible = false
	%GlobalScores.visible = true
