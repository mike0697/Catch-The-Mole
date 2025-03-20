# zucca.gd
extends Area2D

signal clicked
signal timeout

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer

var spawn_point = null

func _ready():
	input_event.connect(_on_input_event)
	timer.timeout.connect(_on_timer_timeout)

func appear(duration):
	# Mostra la zucca
	animation_player.play("appear")
	
	# Imposta il timer per la scomparsa
	timer.wait_time = duration
	timer.start()

func hit():
	# Libera lo spawn point
	if spawn_point:
		spawn_point.set_meta("occupied", false)
	# Animazione quando colpita
	animation_player.play("hit")
	queue_free()

func disappear():
	# Libera lo spawn point
	if spawn_point:
		spawn_point.set_meta("occupied", false)
	# Animazione quando scompare senza essere colpita
	animation_player.play("disappear")
	queue_free()

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# La zucca è stata cliccata
		timer.stop()  # Ferma il timer
		emit_signal("clicked", self)
		# Marca l'evento come gestito per evitare clic multipli
		get_viewport().set_input_as_handled()

func _on_timer_timeout():
	# Tempo scaduto, la zucca non è stata colpita
	emit_signal("timeout", self)
