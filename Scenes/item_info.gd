extends PanelContainer

@onready var icon_rect = $VBoxContainer/HBoxContainer/InfoIcon
@onready var name_label = $VBoxContainer/HBoxContainer/InfoName
@onready var desc_label = $VBoxContainer/InfoDescription

func _ready():
	visible = false # Ukryte na starcie

func display_item(item_data):
	icon_rect.texture = item_data.icon
	name_label.text = item_data.item_name # Upewnij się, że w Resource masz 'item_name'
	desc_label.text = item_data.description
	visible = true
	print('pokazuje okno')

func _input(event):
	# Zamykanie okna po kliknięciu gdziekolwiek indziej lub ponownym kliknięciu
	if event is InputEventMouseButton and event.pressed:
		visible = false
