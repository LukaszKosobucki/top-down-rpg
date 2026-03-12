extends Interactable

@export var required_completed_count: int = 4
@export var target_scene: String = "res://Scenes/Classroom.tscn"

func interact(player):
	var completed_count = 0
	for q_id in QuestManager.quests:
		var q_data = QuestManager.quests[q_id]
		if q_data.get("status") == "completed":
			completed_count += 1
	
	if completed_count >= required_completed_count:
		_show_unlocked_message(player)
	else:
		_show_locked_message(player, completed_count)

func _show_locked_message(player, current_count):
	var ui = get_tree().get_first_node_in_group("dialogue_ui")
	if ui:
		var data = DialogueData.new()
		data.npc_name = "System"
		var progress_text = "\n(Postęp: %d/%d)" % [current_count, required_completed_count]
		
		data.lines = [{
			"text": "Jeszcze jest dużo czasu do lekcji, może pogadam z ludźmi tutaj..." + progress_text,
			"choices": [{"text": "Dobrze", "next_line": -1}],
			# TUTAJ: Aktualizujemy opis zadania w Quest Logu
			"action": {
				"update_desc": {
					"id": "Dojscie_do_szkoly", 
					"value": "czuję że muszę najpierw pogadać z ludźmi dookoła"
				}
			}
		}]
		ui.start_dialogue(data, player)

func _show_unlocked_message(player):
	var ui = get_tree().get_first_node_in_group("dialogue_ui")
	if ui:
		var data = DialogueData.new()
		data.npc_name = "Drzwi"
		data.lines = [{
			"text": "Wszystkie zadania wykonane. Czy chcesz teraz wejść do klasy na lekcję?",
			"choices": [
				{
					"text": "Wejdź do klasy", 
					"next_line": -1, 
					"action": {
						"change_scene": target_scene,
						"play_music": "szkola",
						# TUTAJ: Kończymy zadanie przy wejściu
						"complete_quest": "Dojscie_do_szkoly",
						"complete_desc": "Udało mi się wejść na lekcję punktualnie (chyba)."
					}
				},
				{"text": "Jeszcze rozejrzę się tutaj", "next_line": -1}
			]
		}]
		ui.start_dialogue(data, player)
