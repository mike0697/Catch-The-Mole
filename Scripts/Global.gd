extends Node
#conserva lo score_max tra le partite
var score_max: int = 0
var music = false
var sfx = true
#array contenente i punteggi migliori globali
var best_score = []

func load_data():
	var value = GPX.getItem("keysave")
	if value != null:
		best_score = string_to_array(value)
	
func save_data(data: int):
	load_data() #aggiorna i dati
	var new_record = check_data(data)
	if new_record:
		insert_and_sort_array(best_score, data)
		#salva il dato
		var value = array_to_string(best_score)
		GPX.setItem("keysave", value)
		
#controlla se è stato fatto un nuovo record
func check_data(data : int):
	if data > best_score.min():
		return true
	else:
		return false
		
func insert_and_sort_array(arr: Array, new_value: int) -> Array:
	# Verifica che l'array contenga esattamente 10 elementi
	if arr.size() != 10:
		return arr
	
	# Controlla se il nuovo valore è maggiore del minimo nell'array
	var min_value = arr.min()
	if new_value > min_value:
		# Rimuovi il valore più piccolo
		arr.erase(min_value)
		
		# Aggiungi il nuovo valore
		arr.append(new_value)
		
		# Ordina l'array in ordine crescente
		arr.sort()
	
	return arr

func string_to_array(input_string: String) -> Array:
	# Dividi la stringa in base al separatore '|'
	var numbers = input_string.split('|')
	
	# Converte i numeri in interi e li inserisce nell'array, massimo 10 numeri
	var result_array = []
	for i in range(min(10, numbers.size())):
		result_array.append(int(numbers[i]))
	return result_array

func array_to_string(numbers: Array) -> String:
	# Assicurati che l'array non contenga più di 10 valori
	var limited_numbers = numbers.slice(0, 10)
	
	# Crea un array di stringhe convertendo ogni numero
	var string_array = []
	for number in limited_numbers:
		string_array.append(str(number))
	
	# Unisce l'array di stringhe con il separatore '|'
	return "|".join(string_array)
	
#formatta l' array per inserire i risultati nello board score
func array_to_numbered_string(scores: Array) -> String:
	var result = ""
	
	# Itera sull'array con gli indici
	for i in range(scores.size()):
		result += str(i + 1) + ". " + str(scores[i]) + "\n"
	
	return result
