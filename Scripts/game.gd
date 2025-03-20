extends Node2D

var lives: int = 3 # vite iniziali
var score: int = 0 # score iniziale
# Array per tenere traccia di tutte le talpe attive
var active_moles = []
# Prefab della talpa che verrà istanziato
@export var mole_scene: PackedScene

func _ready():
	%LabelLives.text = "Lives: " + str(lives) + " "
	%LabelScore.text = "Score: " + str(score) + " "
	# Inizia il gioco
	spawn_moles()

func spawn_moles():
	# Timer per generare nuove talpe periodicamente
	var spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = 0.8  # Regola in base alla difficoltà
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
	# Crea una nuova talpa
	var mole = mole_scene.instantiate()
	add_child(mole)
	# Posiziona la talpa nello spawn point scelto
	mole.global_position = random_position.global_position
	# Salva il riferimento allo spawn point nella talpa
	mole.spawn_point = random_position
	# Connetti i segnali della talpa
	mole.connect("clicked", Callable(self, "_on_mole_clicked"))
	mole.connect("timeout", Callable(self, "_on_mole_timeout"))
	# Imposta un timer casuale per la talpa
	mole.appear(randf_range(1.5, 3.0))
	# Aggiungi la talpa all'array delle talpe attive
	active_moles.append(mole)

func _on_mole_clicked(mole):
	# Quando una talpa viene colpita
	update_score(10)  # Aggiungi punti
	mole.hit()  # Attiva l'animazione di colpo
	active_moles.erase(mole)  # Rimuovi dall'array

func _on_mole_timeout(mole):
	# Quando una talpa scompare senza essere colpita
	update_lives(-1)  # Perdi una vita
	mole.disappear()  # Attiva l'animazione di scomparsa
	active_moles.erase(mole)  # Rimuovi dall'array

func update_score(points):
	score = score + points
	%LabelScore.text = "Score: " + str(score) + " "

func update_lives(change):
	#todo metti gli sprite heart per rappresentare le vite
	lives = lives + change
	%LabelLives.text = "Lives: " + str(lives) + " "
	if lives <= 0:
		game_over()

func game_over():
	if score > Global.score_max:
		Global.score_max = score
		#todo game over new record!
	$Menu/GameOver.show()
	get_tree().paused = true
