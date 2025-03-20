extends Node2D

var with = 432
var height = 768
var numero_di_buche_per_riga = 3
var numero_di_buche_per_colonna = 3
var posx
var posy
# Spazio del bordo superiore e inferiore
var bordo_superiore = 250  # Spazio dall'alto
var bordo_inferiore = 250  # Spazio dal basso

# Scena del marker2d
@onready var maker2d_resource = load("res://Scenes/marker_2d.tscn")

func _ready() -> void:
	posx = with / (numero_di_buche_per_riga + 1)  # Calcola la distanza tra una buca e l'altra in orizzontale
	
	# Calcola l'altezza disponibile dopo aver sottratto i bordi
	var altezza_disponibile = height - bordo_superiore - bordo_inferiore
	
	# Calcola la distanza tra le righe all'interno dell'area disponibile
	var distanza_righe = altezza_disponibile / (numero_di_buche_per_colonna - 1) if numero_di_buche_per_colonna > 1 else 0
	
	# Creo tutte le buche per colonna
	for j in range(numero_di_buche_per_colonna):
		
		# Calcola la posizione y tenendo conto del bordo superiore
		var y_position = bordo_superiore
		
		# Se ci sono più di una riga, distribuisci le righe nell'area disponibile
		if numero_di_buche_per_colonna > 1:
			y_position = bordo_superiore + (distanza_righe * j)
		
		# Crea tutte le buche della riga
		for i in range(numero_di_buche_per_riga):
			var marker_instance = maker2d_resource.instantiate()
			var random_offset_x = randf_range(-10, 10)  # Piccola variazione casuale in x
			var random_offset_y = randf_range(-10, 10)  # Piccola variazione casuale in y
			marker_instance.position.x = (posx * (i + 1)) + random_offset_x
			marker_instance.position.y = y_position + random_offset_y
			
			# Aggiungi il metadata per indicare che lo spawn point è libero
			marker_instance.set_meta("occupied", false)
			add_child(marker_instance)
