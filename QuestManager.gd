# QuestManager.gd
extends Node

signal quest_updated # Powiadomienie dla dziennika
signal quest_started(quest_name)
signal quest_completed(quest_name)
# Struktura: "nazwa_questa": "status" (np. "inactive", "started", "completed")
var quests = {}
# Flagi dialogowe: "spotkano_maga": true (do odblokowywania ścieżek)
var flags = {}
var active_auras = []
signal aura_updated(aura_name)

var rps_roman_score = 0
var rps_player_score = 0
var last_player_move = ""
var last_roman_move = ""

func calculate_rps_logic():
	# Roman zawsze wygrywa (przewiduje przyszłość)
	if last_player_move == "Kamień":
		last_roman_move = "Papier"
	elif last_player_move == "Papier":
		last_roman_move = "Nożyce"
	elif last_player_move == "Nożyce":
		last_roman_move = "Kamień"
	
	rps_roman_score += 1
	# Emitujemy sygnał, jeśli Twój UI tego wymaga, 
	# ale formatowanie w DialogueUI powinno wystarczyć.
func start_quest(quest_id: String, description: String = "Brak opisu"):
	quests[quest_id] = {
		"status": "started",
		"description": description
	}	
	quest_started.emit(quest_id.replace("_", " "))
	quest_updated.emit()
	print("Zadanie rozpoczęte: ", quest_id)

func complete_quest(quest_id: String, new_description: String = ""):
	if quests.has(quest_id):
		quests[quest_id]["status"] = "completed"
		if new_description != "":
			quests[quest_id]["description"] = new_description
		quest_completed.emit(quest_id.replace("_", " "))
		quest_updated.emit()
		print("Zadanie zakończone: ", quest_id)

func get_quest_status(quest_id: String) -> String:
	return quests.get(quest_id, {}).get("status", "inactive")
	
		
func update_quest_status(q_id: String, new_status: String):
	if quests.has(q_id):
		quests[q_id]["status"] = new_status
		quest_updated.emit()
		print("Quest ", q_id, " zmienił status na: ", new_status)

func update_quest_description(q_id: String, new_desc: String):
	if quests.has(q_id):
		quests[q_id]["description"] = new_desc
		quest_updated.emit()
		print("Quest ", q_id, " zmienił opis.")
	
func set_flag(flag_name: String, value: bool = true):
	flags[flag_name] = value

func get_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)

# Funkcja pomocnicza do sprawdzania przedmiotów u gracza
func player_has_item(item_name: String) -> bool:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		for item in player.inventory:
			if item.item_name == item_name:
				return true
	return false

func remove_item_from_player(item_name: String):
	var player = get_tree().get_first_node_in_group("player")
	if player:
		for i in range(player.inventory.size()):
			if player.inventory[i].item_name == item_name:
				player.inventory.remove_at(i)
				player.inventory_updated.emit() # Odśwież hotbar
				return
				
func add_aura(aura_name: String):
	if not active_auras.has(aura_name):
		active_auras.append(aura_name)
		aura_updated.emit(aura_name) 
		print("Zyskałeś aurę i wysłano sygnał: ", aura_name)
		
func has_aura(aura_name: String) -> bool:
	return active_auras.has(aura_name)
