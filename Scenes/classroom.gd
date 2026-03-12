# res://Scenes/Classroom.gd
extends Node2D

@export var birthday_dialogue: DialogueData 
@export var auto_transition_time: float = 5.0 # Czas po jakim włączą się napisy bez dialogu

func _ready():
	# 1. Startujemy muzykę
	if MusicPlayer.has_method("play_track"):
		MusicPlayer.play_track("szkola")

	var ui = get_tree().get_first_node_in_group("dialogue_ui")
	var player = get_tree().get_first_node_in_group("player")

	if ui and birthday_dialogue:
		# Czekamy chwilę, aby uniknąć "przeklikania" z poprzedniej sceny
		print('probuje wlaczyc dialog')
		await get_tree().create_timer(1.0).timeout
		ui.start_dialogue(birthday_dialogue, player)
	else:
		# JEŚLI NIE MA DIALOGU: Czekamy chwilę i sami włączamy Credits
		print("Brak dialogu, włączam napisy automatycznie za ", auto_transition_time, "s")
		await get_tree().create_timer(auto_transition_time).timeout
		
		# Wywołujemy ściemnianie i zmianę sceny bezpośrednio przez UI
		if ui and ui.has_method("fade_to_black"):
			await ui.fade_to_black(4.0)
		get_tree().change_scene_to_file("res://Scenes/Credits.tscn")
