extends Node
#conserva lo score_max tra le partite
var score_max: int = 0
var music = true
var sfx = true
#array contenente i punteggi migliori globali
var best_score = []

func load_data():
	var value = GPX.getItem("keysave")
	if value != null:
		print(str(value))
		best_score = string_to_array(value)
	else:
		if best_score.size() < 10:
			best_score.append(0)
			var str = array_to_string(best_score)
			GPX.setItem("keysave", str)
		
	
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
	if best_score.min() != null:
		if data > best_score.min():
			return true
		else:
			return false
	else:
		return true
		
func insert_and_sort_array(arr: Array, new_value: int) -> Array:
	if arr == null:
		print("errore array == null")
		return arr
		
	if arr.size() < 10:
		#aggiunge il valore all' array e lo ordina
		arr.append(new_value)
		arr.sort()
		return arr
	else:
		# Controlla se il nuovo valore è maggiore del minimo nell'array
		var min_value = arr.min()
		if new_value > min_value:
			arr.erase(min_value)
			arr.append(new_value)
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
	#inverte l' array
	scores.reverse()
	# Itera sull'array con gli indici
	for i in range(scores.size()):
		result += str(i + 1) + ". " + str(scores[i]) + "\n"
	
	return result
