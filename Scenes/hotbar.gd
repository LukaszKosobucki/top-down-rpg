# Hotbar.gd
extends CanvasLayer

@onready var slots_container =$HotbarContainer/MarginContainer/HBoxContainer
@onready var info_window = $HotbarContainer/ItemInfoWindow # Ścieżka do nowego okna

func _ready():
	# Znajdź gracza i połącz się z jego sygnałem (opcjonalnie, ale polecane)
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.inventory_updated.connect(update_hotbar)
	
	# Pierwsze odświeżenie na starcie
	setup_slots()
	update_hotbar()

func setup_slots():
	# Przechodzimy przez wszystkie sloty i podpinamy ich sygnał kliknięcia
	for slot in slots_container.get_children():
		if not slot.slot_clicked.is_connected(_on_slot_clicked):
			slot.slot_clicked.connect(_on_slot_clicked)

func _on_slot_clicked(data):
	info_window.display_item(data)
	# Opcjonalnie: ustaw pozycję okna nad klikniętym slotem
	info_window.global_position = get_viewport().get_mouse_position() + Vector2(10, -100)

func update_hotbar():
	var player = get_tree().get_first_node_in_group("player")
	if not player: return
	
	var inventory = player.inventory # Twoja tablica z przedmiotami
	var slots = slots_container.get_children()
	print("update hotbar")

	for i in range(slots.size()):
		if i < inventory.size():
			# Jeśli w tablicy jest przedmiot pod tym indeksem, pokaż go
			slots[i].update_slot(inventory[i])
		else:
			# Jeśli tablica jest krótsza, wyczyść slot
			slots[i].update_slot(null)
