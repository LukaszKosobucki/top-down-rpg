# World.gd
extends Node2D

func _ready():
	# 1. Uruchom muzykę szkolną (Singleton)
	if MusicPlayer.has_method("play_track"):
		MusicPlayer.play_track("default")
		
	# 2. Odpal monolog z małym opóźnieniem (pół sekundy)
	# Daje to graczowi chwilę na zobaczenie Wiktora przed wyskakującym UI
	_start_intro_sequence()

func _start_intro_sequence():
	var ui = get_tree().get_first_node_in_group("dialogue_ui")
	var player = get_tree().get_first_node_in_group("player")
	var intro_res = load("res://Resources/Dialogs/Internal/Wiktor_intro_data.tres")
	
	if ui and intro_res and player:
		# 1. Zaczynamy powolne rozjaśnianie (np. 3 sekundy)
		ui.fade_from_black(3.0)
		
	
		# 3. Startujemy monolog
		ui.start_dialogue(intro_res, player)
