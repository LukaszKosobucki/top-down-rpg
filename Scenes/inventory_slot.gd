# InventorySlot.gd
extends PanelContainer

signal slot_clicked(item_data) # Nowy sygnał

var current_item_data = null # Przechowujemy dane aktualnego przedmiotu

@onready var icon_rect = $Icon
@onready var quantity_label = $Label

func update_slot(item_data):
	print("update slot")
	current_item_data = item_data
	if item_data == null:
		icon_rect.texture = null
		quantity_label.text = ""
	else:
		icon_rect.texture = item_data.icon # Zakładając, że masz Resource przedmiotu
		print("update slot icona")

		if item_data.stackable:
			quantity_label.text = str(item_data.quantity)
		else:
			quantity_label.text = ""


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if current_item_data != null:
				print("Wysyłam sygnał dla: ", current_item_data.item_name)
				slot_clicked.emit(current_item_data)
