extends Node2D
class_name Interactable

@export var interaction_text: String = "Interact"
@onready var sprite: Sprite2D = $Sprite2D
var original_material: Material

func interact(player):
	print("Interacted with ", name)

func _ready():
	if sprite:
		original_material = sprite.material

	if sprite and sprite.material:
		sprite.material = sprite.material.duplicate()
		sprite.material.set_shader_parameter("outline_size", 0.0)

func set_highlight(enabled: bool):
	if not sprite:
		return
		
	if not sprite.material:
		return  # No shader = no highlight
	
	if enabled:
		sprite.material.set_shader_parameter("outline_size", 1.0)
	else:
		sprite.material.set_shader_parameter("outline_size", 0.0)
