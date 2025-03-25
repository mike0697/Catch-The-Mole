extends Node2D

@export_group("Game Objects")
@export var mole_scene: PackedScene
@export var pumpkin_scene: PackedScene

# Variabili per la difficoltà
var difficulty_level: int = 1
var max_difficulty: int = 15
var points_to_next_level: int = 100 # level *(points + (difficulty_level * 10))
var spawn_interval: float = 0.9
var min_spawn_interval: float = 0.25
var spawn_interval_decrease: float = 0.1
var spawn_interval_decrease_after_level_five = 0.05
var spawn_interval_decrease_after_level_seven = 0.02
var mole_duration_max: float = 2.6
var mole_duration_min: float = 1.5
var pumpkin_chance: float = 0.3

# Variabili di stato del gioco
var lives: int = 3 # vite iniziali
var score: int = 0 # score iniziale


# Tracciamento degli oggetti di gioco
var active_moles = []
var active_pumpkins = []
var spawn_timer: Timer

func _ready():
	initialize_game()
	spawn_objects()
	
func initialize_game():
	%LabelLives.text = "Lives: " + str(lives)
	%LabelScore.text = "Score: " + str(score)
	%LevelLabel.text = "Level: " + str(difficulty_level)

func spawn_objects():
	# Timer per generare nuove talpe periodicamente
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

func _on_spawn_timer_timeout():
	# Ottieni tutti i punti disponibili
	var positions = $MolePositions.get_children()
	# Filtra per trovare solo le posizioni libere
	var free_positions = []
	for pos in positions:
		if not pos.get_meta("occupied"):
			free_positions.append(pos)
	# Se non ci sono posizioni libere, esci dalla funzione
	if free_positions.size() == 0:
		print("nessuna posizione libera")
		return
	# Seleziona una posizione libera casuale
	var random_position = free_positions[randi() % free_positions.size()]
	# Marca la posizione come occupata
	random_position.set_meta("occupied", true)
	
	# Decidi casualmente se spawnare una talpa o una zucca (probabilità basata sul livello)
	if randf() < (1.0 - pumpkin_chance):
		spawn_mole(random_position)
	else:
		spawn_pumpkin(random_position)
	
func spawn_mole(position):
	# Crea una nuova talpa
	var mole = mole_scene.instantiate()
	add_child(mole)
	# Posiziona la talpa nello spawn point scelto
	mole.global_position = position.global_position
	# Salva il riferimento allo spawn point nella talpa
	mole.spawn_point = position
	# Connetti i segnali della talpa
	mole.connect("clicked", Callable(self, "_on_mole_clicked"))
	mole.connect("timeout", Callable(self, "_on_mole_timeout"))
	
	# Durata della talpa basata sulla difficoltà
	var duration = mole_duration_max - ((difficulty_level - 1) * 0.15)
	duration = max(duration, mole_duration_min)  # Non scendere sotto il minimo
	
	mole.appear(duration)
	# Aggiungi la talpa all'array delle talpe attive
	active_moles.append(mole)
	
func spawn_pumpkin(position):
	# Crea una nuova zucca
	var pumpkin = pumpkin_scene.instantiate()
	add_child(pumpkin)
	# Posiziona la zucca nello spawn point scelto
	pumpkin.global_position = position.global_position
	# Salva il riferimento allo spawn point nella zucca
	pumpkin.spawn_point = position
	# Connetti i segnali della zucca
	pumpkin.connect("clicked", Callable(self, "_on_pumpkin_clicked"))
	pumpkin.connect("timeout", Callable(self, "_on_pumpkin_timeout"))
	
	# Durata della zucca basata sulla difficoltà
	var duration = mole_duration_max - ((difficulty_level - 1) * 0.1)
	duration = max(duration, mole_duration_min)
	
	pumpkin.appear(duration)
	# Aggiungi la zucca all'array delle zucche attive
	active_pumpkins.append(pumpkin)
	
func _on_mole_clicked(mole):
	# Quando una talpa viene colpita
	%SoundHit.play()
	update_score(10)  # Aggiungi punti
	mole.hit()  # Attiva l'animazione di colpo
	active_moles.erase(mole)  # Rimuovi dall'array

func _on_mole_timeout(mole):
	# Quando una talpa scompare senza essere colpita
	update_lives(-1)  # Perdi una vita
	mole.disappear()  # Attiva l'animazione di scomparsa
	active_moles.erase(mole)  # Rimuovi dall'array
	
func _on_pumpkin_clicked(pumpkin):
	# Quando una zucca viene colpita
	%SoundHit2.play()
	update_lives(-1)  # Perdi una vita (effetto negativo)
	pumpkin.hit()  # Attiva l'animazione di colpo
	active_pumpkins.erase(pumpkin)  # Rimuovi dall'array

func _on_pumpkin_timeout(pumpkin):
	# Quando una zucca scompare senza essere colpita
	# Non succede nulla di negativo, anzi è meglio non colpirla
	pumpkin.disappear()  # Attiva l'animazione di scomparsa
	active_pumpkins.erase(pumpkin)  # Rimuovi dall'array

func update_score(points):
	score = score + points
	%LabelScore.text = "Score: " + str(score) + " "
	
	# Controlla se è il momento di aumentare la difficoltà
	check_difficulty_increase()

func check_difficulty_increase():
	if difficulty_level >= max_difficulty:
		return  # Già al livello massimo
		
	var next_level_threshold = difficulty_level * (points_to_next_level + (difficulty_level * 10))
	
	if score >= next_level_threshold:
		increase_difficulty()

func increase_difficulty():
	difficulty_level += 1
	
	# Aggiorna l'etichetta del livello
	%LevelLabel.text = "Level: " + str(difficulty_level)
	
	# Mostra un messaggio di livello
	show_level_message()
	
	# Modifica l'intervallo di spawn in base al livello di difficoltà
	if difficulty_level < 5:
		# Livelli da 1 a 4
		spawn_interval -= spawn_interval_decrease
	elif difficulty_level < 7:
		# Livelli da 5 a 7
		spawn_interval -= spawn_interval_decrease_after_level_five
	else:
		# Livelli da 7 in su
		spawn_interval -= spawn_interval_decrease_after_level_seven
		
	spawn_interval = max(spawn_interval, min_spawn_interval)
	spawn_timer.wait_time = spawn_interval
	
	# Aumenta la probabilità di zucche
	pumpkin_chance = min(pumpkin_chance + 0.05, 0.5)  # Max 50% zucche
	
	# Puoi anche modificare altre variabili in base al livello
	print("Livello aumentato a: ", difficulty_level)
	print("Intervallo di spawn: ", spawn_interval)
	print("Probabilità zucca: ", pumpkin_chance)

func show_level_message():
	var level_label = Label.new()
	level_label.text = "Level " + str(difficulty_level)
	level_label.theme = preload("res://theme/theme.tres")
	level_label.add_theme_font_size_override("font_size", 35)
	level_label.set_anchors_preset(Control.PRESET_CENTER)
	level_label.position = Vector2(140, 384)  # Posizione al centro dello schermo
	level_label.modulate = Color(1, 1, 1, 1)
	add_child(level_label)
	
	# Animazione per il messaggio di livello
	var tween = create_tween()
	tween.tween_property(level_label, "modulate", Color(1, 1, 1, 0), 2.0)
	tween.tween_callback(level_label.queue_free)
	
	# Puoi aggiungere un effetto sonoro qui
	# %SoundLevelUp.play()

func update_lives(change):
	lives = lives + change
	%LabelLives.text = "Lives: " + str(lives) + " "
	if lives <= 0:
		game_over()

func game_over():
	if score > Global.score_max:
		Global.score_max = score
		%NewRecordLabel.visible = true
		Global.load_data()
		var new_record = Global.check_data(score)
		if new_record:
			Global.save_data(score)
			%ScoreBoard.visible = true
		else:
			%ScoreBoard.visible = false
	else:
		%NewRecordLabel.visible = false
	%ScoreLabel.text = "Score: " + str(score) + " "
	$Menu/GameOver.show()
	get_tree().paused = true
