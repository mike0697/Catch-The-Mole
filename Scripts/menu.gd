extends CanvasLayer


func _ready() -> void:
	%StartMenu.visible = true
	%GameOver.visible = false
	%MaxScoreLabel.text = "Max Score: " + str(Global.score_max)
	get_tree().paused = true
	


func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	%StartMenu.visible = false
	%GameOver.visible = false
	get_tree().paused = false


func _on_retry_pressed() -> void:
	%StartMenu.visible = false
	%GameOver.visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()
