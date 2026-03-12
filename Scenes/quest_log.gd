extends CanvasLayer

@onready var log_window = $Panel/PanelContainer
@onready var log_icon = $Panel/TextureButton
@onready var active_list = $Panel/PanelContainer/VBoxContainer/TabContainer/Aktywne/VBoxContainer
@onready var completed_list = $Panel/PanelContainer/VBoxContainer/TabContainer/Zakończone/VBoxContainer
@onready var tab_container = $Panel/PanelContainer/VBoxContainer/TabContainer
var quest_entry_scene = preload("res://Scenes/QuestEntry.tscn")

func _ready():
	QuestManager.quest_updated.connect(refresh_log)
	log_window.visible = false
	log_icon.visible = true
	refresh_log()
	var tab_bar = tab_container.get_tab_bar()
	if tab_bar:
		tab_bar.focus_mode = Control.FOCUS_NONE

func _on_texture_button_pressed():
	log_window.visible = true
	log_icon.visible = false
	refresh_log()

func _on_close_button_pressed():
	log_window.visible = false
	log_icon.visible = true

func refresh_log():
	_clear_container(active_list)
	_clear_container(completed_list)

	print("--- ODŚWIEŻANIE DZIENNIKA ---")
	var has_active = false
	
	for q_id in QuestManager.quests:
		var q_data = QuestManager.quests[q_id]
		
		if quest_entry_scene == null:
			print("BŁĄD: Brak sceny QuestEntry!")
			return

		var entry = quest_entry_scene.instantiate()
		
		# LOGIKA NAPRAWIONA:
		# Jeśli status to "completed" -> do listy ukończonych.
		# KAŻDY INNY status (started, szukanie_dziewczynki, itp.) -> do aktywnych.
		if q_data["status"] == "completed":
			completed_list.add_child(entry)
		else:
			active_list.add_child(entry)
			has_active = true
		
		# BARDZO WAŻNE: Wywołujemy setup po add_child.
		# To gwarantuje, że węzły wewnątrz entry (@onready) nie będą Nil.
		entry.setup(q_id.replace("_", " "), q_data["description"])

	if not has_active:
		var empty_label = Label.new()
		empty_label.text = "Brak aktywnych zadań"
		empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		active_list.add_child(empty_label)

func _clear_container(container):
	if container:
		for child in container.get_children():
			child.queue_free()
