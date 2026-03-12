extends CanvasLayer

@onready var panel = $NotificationContainer/PanelContainer
@onready var label = $NotificationContainer/PanelContainer/MessageLabel

func _ready():
	# Ukrywamy panel poza ekranem na starcie
	panel.position.y = -100
	
	# Podpinamy się pod sygnał menedżera zadań
	QuestManager.quest_updated.connect(_on_quest_updated)
	QuestManager.quest_started.connect(func(name): show_notification("NOWE ZADANIE: " + name, Color.GOLD))
	QuestManager.quest_completed.connect(func(name): show_notification("ZADANIE UKOŃCZONE: " + name, Color.GREEN))

func show_notification(text: String, color: Color = Color.WHITE):
	label.text = text
	label.add_theme_color_override("font_color", color)
	
	# Animacja wjazdu (Godot 4 Tweens)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	# Zjeżdża w dół
	tween.tween_property(panel, "position:y", 20, 0.5)
	# Czeka 3 sekundy
	tween.tween_interval(3.0)
	# Wraca do góry
	tween.tween_property(panel, "position:y", -100, 0.5)

func _on_quest_updated():
	# Tutaj możemy wyciągnąć ostatnią zmianę z QuestManagera
	# Na potrzeby testu wyświetlmy ogólne info:
	show_notification("Dziennik zadań zaktualizowany!", Color.YELLOW)
