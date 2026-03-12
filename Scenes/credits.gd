extends Control

@export_multiline var credits_text: String = "TWÓJ TYTUŁ GRY..."
@export var scroll_speed: float = 50.0 
@export var finish_delay: float = 2.0  
@onready var quit_button = $QuitButton # Podepnij swój przycisk
@onready var label = $CreditsLabel

func _ready():
	# 1. Ustawiamy tekst
	label.text = credits_text
	MusicPlayer.play_track("szkola")	
	# KLUCZOWE: Czekamy jedną klatkę, aż Godot obliczy rzeczywisty rozmiar tekstu
	await get_tree().process_frame
	
	# 2. Resetujemy kotwice (anchors), żeby nie "biły się" ze skryptem
	label.anchors_preset = Control.PRESET_TOP_LEFT
	
	var screen_size = get_viewport_rect().size
	label.size.x = screen_size.x
	
	# 3. Ustawiamy start: góra tekstu ma być na dole ekranu
	label.position.y = screen_size.y
	
	# 4. Obliczamy dystans (wysokość ekranu + wysokość całego tekstu)
	var total_distance = screen_size.y + label.size.y
	var duration = total_distance / scroll_speed
	
	# Debugowanie - sprawdź w konsoli, czy liczby się zgadzają
	print("Wysokość tekstu: ", label.size.y)
	print("Czas trwania: ", duration)

	# 5. Animacja
	var tween = create_tween()
	# Jedziemy aż dół tekstu zniknie za górną krawędzią (pozycja: -wysokość_tekstu)
	tween.tween_property(label, "position:y", -label.size.y, duration)
	
	tween.finished.connect(_on_finished)
	


func _on_finished():
	await get_tree().create_timer(finish_delay).timeout
	get_tree().quit()

func _on_quit_button_pressed():
	# Oficjalne wyjście z gry
	get_tree().quit()
