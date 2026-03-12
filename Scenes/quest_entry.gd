extends VBoxContainer

# Odwołania do dzieci
@onready var title_button = $Button
@onready var description_label = $Label

func setup(title_text: String, desc_text: String):
	# Ustawiamy teksty przekazane z QuestLoga
	print("Setup wpisu: ", title_text, desc_text)
	title_button.text = title_text
	description_label.text = desc_text
	# Upewniamy się, że opis jest schowany na początku
	description_label.visible = false

# To wywoła się, gdy klikniesz w tytuł zadania
func _on_button_pressed() -> void:
	# Magia rozsuwania: jeśli był widoczny, to schowaj, i na odwrót
	description_label.visible = !description_label.visible
