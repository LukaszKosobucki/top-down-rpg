extends CanvasLayer

@onready var npc_name_label = get_node_or_null("PanelContainer/Panel/NPCName")
@onready var dialogue_label = get_node_or_null("PanelContainer/Panel/DialogueText")
@onready var choices_container: VBoxContainer = get_node_or_null("PanelContainer/Panel/ChoicesContainer")
@onready var fade_overlay: ColorRect = get_node_or_null("FadeOverlay")
var is_ending_game_sequence := false # Nowa flaga
var dialogue: DialogueData
var current_line_index  := 0
var player_locked := false
var player_ref: CharacterBody2D = null

var is_ending_game := false # Flaga na górze skryptu

func start_dialogue(data: DialogueData, player):
	dialogue = data
	current_line_index  = 0
	player_locked = true
	player_ref = player
	player_ref.set_process(false)  # Stops player's _process / movement
	show()
	_update_text()


func _update_text():
	_clear_choices()
	
	if not dialogue:
		return
	
	if current_line_index >= dialogue.lines.size() or current_line_index < 0:
		end_dialogue()
		print("started")
		return

	var line = dialogue.lines[current_line_index]
	# Dzięki temu muzyka u Piotra ruszy od razu po otwarciu okna!
	_execute_choice_action(line)
	
	npc_name_label.text = dialogue.npc_name
	# DialogueUI.gd (wewnątrz _update_text)
	var raw_text = line.get("text", "")
	# Podmieniamy zmienne z QuestManagera
	raw_text = raw_text.format({
		"roman_score": QuestManager.rps_roman_score,
		"player_score": QuestManager.rps_player_score,
		"roman_move": QuestManager.last_roman_move,
		"player_move": QuestManager.last_player_move
	})
	dialogue_label.text = raw_text

	# Check if line has choices
	var choices = line.get("choices", [])
	if choices.size() > 0:
		for choice_dict in choices:
			if not _check_choice_condition(choice_dict):
				continue # Pomiń tę opcję, jeśli warunek nie jest spełniony
			
	
			var btn = Button.new()
			btn.text = choice_dict["text"]
			
			btn.add_theme_font_size_override("font_size", 4)
			var stylebox = btn.get_theme_stylebox("normal").duplicate()
			stylebox.content_margin_left = 4
			stylebox.content_margin_right = 4
			stylebox.content_margin_top = 0
			stylebox.content_margin_bottom = 0

			btn.add_theme_stylebox_override("normal", stylebox)
			btn.set_h_size_flags(Control.SIZE_SHRINK_BEGIN)
			btn.set_v_size_flags(Control.SIZE_SHRINK_CENTER)
	

			btn.pressed.connect(func(c=choice_dict): _on_choice_selected(c))
			choices_container.add_child(btn)
	else:
		# No choices, show continue button
		var continue_btn = Button.new()
		continue_btn.text = "Continue"
		
		continue_btn.add_theme_font_size_override("font_size", 4)
		var stylebox = continue_btn.get_theme_stylebox("normal").duplicate()
		stylebox.content_margin_left = 4
		stylebox.content_margin_right = 4
		stylebox.content_margin_top = 0
		stylebox.content_margin_bottom = 0

		continue_btn.add_theme_stylebox_override("normal", stylebox)
		continue_btn.set_h_size_flags(Control.SIZE_SHRINK_BEGIN)
		continue_btn.set_v_size_flags(Control.SIZE_SHRINK_CENTER)
		
		continue_btn.pressed.connect(func(): next_line())
		choices_container.add_child(continue_btn)

func next_line():
	current_line_index  += 1
	_update_text()
	
func _clear_choices():
	for child in choices_container.get_children():
		child.queue_free()
	
func _check_choice_condition(choice: Dictionary) -> bool:
	var req = choice.get("requires", {})
	if req.is_empty(): return true
	
	# Sprawdzanie przedmiotu i ilości
	if req.has("item"):
		var item_name = req["item"]
		var count = req.get("count", 1) # Jeśli nie podano, domyślnie 1
		if player_ref and not player_ref.has_item_count(item_name, count):
			return false
			
	# Reszta Twoich warunków (quest_status, flag) zostaje bez zmian
	if req.has("quest_status"):
		var q_data = req["quest_status"]
		if QuestManager.get_quest_status(q_data[0]) != q_data[1]:
			return false
	if req.has("flag") and not QuestManager.get_flag(req["flag"]):
		return false
		
	return true
	

func _on_choice_selected(choice_dict: Dictionary):
	var act = choice_dict.get("action", {})
	
	# PANCERNE ZABEZPIECZENIE: Sprawdzamy, czy to koniec gry, 
	# ALBO czy dialog próbuje wymusić zmianę na scenę Credits
	var is_final_action = act.has("end_game") or (act.has("change_scene") and "Credits" in act["change_scene"])
	
	if is_final_action:
		is_ending_game_sequence = true
		_execute_choice_action(choice_dict)
		return # ZATRZYMUJEMY KOD TUTAJ - nie pozwalamy wywołać end_dialogue()!
	_execute_choice_action(choice_dict)
	var next_idx = choice_dict.get("next_line", -1)
	if next_idx < 0:
		end_dialogue()
	else:
		current_line_index = next_idx
		_update_text()

func _execute_choice_action(choice: Dictionary):
	var act = choice.get("action", {})
	if act.is_empty(): return
	
	# PANCERNY BLOK KOŃCA GRY - Zawsze na samej górze!
	var is_final_action = act.has("end_game") or (act.has("change_scene") and "Credits" in act["change_scene"])
	
	if is_final_action:
		choices_container.hide() # Ukrywamy przyciski, żeby nikt nie klikał dwa razy
		
		# Pilnujemy, by leciało "Sto lat" (szkola)
		if MusicPlayer.has_method("play_track"):
			MusicPlayer.play_track("szkola") 
			
		print("DEBUG: Rozpoczynam animację fade_to_black!")
		
		# Animacja wygaszania (czeka 4 sekundy)
		if has_method("fade_to_black"):
			await fade_to_black(4.0) 
			
		# DOPIERO TERAZ zmieniamy scenę
		get_tree().change_scene_to_file("res://Scenes/Credits.tscn")
		return # KOŃCZYMY FUNKCJĘ - ignorujemy wszystkie inne akcje poniżej
	
	
	if act.has("start_quest"):
		var desc = act.get("quest_desc", "Brak opisu")
		QuestManager.start_quest(act["start_quest"], desc)
	if act.has("complete_quest"):
		var finish_desc = act.get("complete_desc", "") # Szukamy opisu zakończenia
		QuestManager.complete_quest(act["complete_quest"], finish_desc)
	if act.has("give_flag"):
		QuestManager.set_flag(act["give_flag"])
	if act.has("remove_item"):
		QuestManager.remove_item_from_player(act["remove_item"])

	if act.has("add_item") and player_ref:
		player_ref.add_item_by_path(act["add_item"])
		
	if act.has("remove_item") and player_ref:
		var count = act.get("count", 1)
		player_ref.remove_item_by_name(act["remove_item"], count)
	if act.has("change_scene"):
		# Opcjonalnie: możesz tu dodać małe opóźnienie lub efekt ściemnienia
		get_tree().change_scene_to_file(act["change_scene"])
	if act.has("update_status"):
		var data = act["update_status"]
		if data is Dictionary and data.has("id") and data.has("value"):
			QuestManager.update_quest_status(data["id"], data["value"])
		else:
			print("BŁĄD: Niepoprawny format update_status: ", data)
	if act.has("add_aura"):
		QuestManager.add_aura(act["add_aura"])
	if act.has("update_desc"):
		var data = act["update_desc"]
		if data is Dictionary and data.has("id") and data.has("value"):
			QuestManager.update_quest_description(data["id"], data["value"])
	if act.has("set_player_move"):
		QuestManager.last_player_move = act["set_player_move"]
	if act.has("play_music"):
		if MusicPlayer.has_method("play_track"):
			MusicPlayer.play_track(act["play_music"])

	if act.has("calculate_rps"):
		QuestManager.calculate_rps_logic()

			
func end_dialogue():
	if is_ending_game_sequence:
		hide()
		return
	
	hide()
	if player_locked and player_ref:
		player_ref.set_process(true)
		

			
	if not is_ending_game:
		if MusicPlayer.has_method("play_track"):
			# Upewnij się, że tu nie ma play_track("default") jeśli chcesz by grało to co gra
			MusicPlayer.play_track("default")
	player_locked = false
	player_ref = null
	dialogue = null

func _on_button_pressed() -> void:
	next_line()
	
func fade_from_black(duration: float = 2.0):
	if not fade_overlay:
		return
		
	fade_overlay.show()
	fade_overlay.modulate.a = 1.0 # Zaczynamy od pełnej czerni
	
	var tween = create_tween()
	# Animujemy kanał alfa (przezroczystość) od 1 do 0
	tween.tween_property(fade_overlay, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_SINE)
	
	await tween.finished
	fade_overlay.hide()
	
	
func fade_to_black(duration: float = 3.0):
	if not fade_overlay:
		print("BŁĄD: Brak węzła FadeOverlay w DialogueUI!")
		return
	
	fade_overlay.show()
	fade_overlay.modulate.a = 0.0 # Zaczynamy od przezroczystości
	
	var tween = create_tween()
	# Animujemy kanał alfa do 1.0 (pełna czerń)
	tween.tween_property(fade_overlay, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_SINE)
	
	# Czekamy aż animacja się skończy
	await tween.finished
