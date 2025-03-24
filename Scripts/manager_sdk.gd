extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_data()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func new_record():
	GPX.setItem("keysave", "0")


func load_data():
	var value = GPX.getItem("keysave")
	if value != null:
		%Scores.text = str(value)
	else:
		print("nessun valore")
		new_record()


func _on_global_scores_pressed() -> void:
	load_data()
	
	
	

#salvo i primi dieci record 	

# Conversione da array di interi a stringa
func integers_to_string(values):
	var result = ""
	
	for i in range(values.size()):
		result += str(values[i])
		if i < values.size() - 1:
			result += "|"  # Uso il pipe come separatore, ma puoi usare qualsiasi carattere
	
	return result

# Conversione da stringa ad array di interi
func string_to_integers(str_values):
	var parts = str_values.split("|")
	var values = []
	
	for part in parts:
		values.append(int(part))
	
	return values

# Esempio di utilizzo
func test_conversion():
	var values = [10, 25, 43, 67, 82, 91, 105, 234, 567, 890]
	
	# Conversione in stringa
	var encoded = integers_to_string(values)
	print("Stringa codificata: ", encoded)
	
	# Riconversione in array di interi
	var decoded = string_to_integers(encoded)
	print("Array decodificato: ", decoded)
