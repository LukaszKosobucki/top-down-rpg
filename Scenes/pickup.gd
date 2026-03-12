@tool # Pozwala widzieć zmiany rozmiaru od razu w edytorze
extends Interactable

@export var item_data: ItemData:
	set(value):
		item_data = value
		_update_item_visuals()

# Docelowy rozmiar obrazka w świecie gry (np. 16x16 px)
@export var target_display_size: float = 16.0:
	set(value):
		target_display_size = value
		_update_item_visuals()

@onready var collision: CollisionShape2D = $InteractionArea/CollisionShape2D

func _ready():
	_update_item_visuals()
	update_collision_shape()

func _update_item_visuals():
	# Bezpieczne pobranie node'a (ważne dla @tool)
	if sprite == null: sprite = get_node_or_null("Sprite2D")
	
	if sprite and item_data and item_data.icon:
		sprite.texture = item_data.icon
		
		# TRIK SKALOWANIA:
		# Pobieramy większy bok tekstury, żeby zachować proporcje (fit-in)
		var tex_size = item_data.icon.get_size()
		var max_side = max(tex_size.x, tex_size.y)
		
		if max_side > 0:
			var s = target_display_size / max_side
			sprite.scale = Vector2(s, s)

func interact(player):
	if item_data:
		player.add_item_by_path(item_data.resource_path)
		queue_free()

func update_collision_shape():
	if collision == null: collision = get_node_or_null("InteractionArea/CollisionShape2D")
	if not collision: return
	
	var shape = RectangleShape2D.new()
	# Ustawiamy kolizję na sztywne 16x16 niezależnie od grafiki
	shape.size = Vector2(16, 16)
	collision.shape = shape
