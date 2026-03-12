extends CanvasLayer

@onready var label = $Label

func _ready():
	hide_prompt()

func show_prompt(action_text: String):
	label.text = "[E] to " + action_text
	visible = true

func hide_prompt():
	visible = false
