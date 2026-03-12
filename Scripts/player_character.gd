extends CharacterBody2D
#
## Node paths for UI elements (optional)
#export(NodePath) var health_bar_path = "UI/HealthBar"
#export(NodePath) var mana_bar_path = "UI/ManaBar"

var speed: float = 100.0
var current_speed = 100.0
var moving_direction: Vector2 = Vector2.ZERO
var animation_direction: String = "idle_front"
var last_moving_direction: Vector2 = Vector2.DOWN 
var animated_sprite: AnimatedSprite2D
@onready var interaction_ui = get_tree().current_scene.get_node("InteractionUI")
@onready var interaction_area = $InteractionArea
var current_interactable: Interactable = null
var inventory: Array = []
signal inventory_updated # Sygnał informujący UI o zmianach

var interactables_in_range = []

## UI elements (optional)
#onready var health_bar: ProgressBar = $health_bar_path
#onready var mana_bar: ProgressBar = $mana_bar_path

# Optional: Update UI elements based on character stats (e.g., health, mana)
#func update_health(new_health: float):
	#if health_bar:
		#health_bar.value = new_health
#
#func update_mana(new_mana: float):
	#if mana_bar:
		#mana_bar.value = new_mana



func add_item_by_path(path: String):
	var item_res = load(path)
	if item_res:
		inventory.append(item_res)
		inventory_updated.emit() # Hotbar to usłyszy i się odświeży
		print("Gracz otrzymał: ", item_res.item_name)

func has_item_count(item_name: String, amount: int) -> bool:
	var count = 0
	for item in inventory:
		# Zakładam, że Twój Resource ma zmienną 'item_name'
		if item and item.item_name == item_name:
			count += 1
	return count >= amount

func remove_item_by_name(item_name: String, amount: int):
	var removed_count = 0
	var i = inventory.size() - 1
	while i >= 0 and removed_count < amount:
		if inventory[i].item_name == item_name:
			inventory.remove_at(i)
			removed_count += 1
		i -= 1
	inventory_updated.emit()


func _ready():
	# Get reference to AnimatedSprite2D
	animated_sprite = $Sprite  # Adjust path if needed
	if animated_sprite == null:
		print("Warning: AnimatedSprite2D not found!")
	interaction_area.area_entered.connect(_on_area_entered)
	interaction_area.area_exited.connect(_on_area_exited)
		# You might want to handle this case or create one programmatically
	#if health_bar and mana_bar:
		#health_bar.max_value = 100.0
		#mana_bar.max_value = 50.0
	if QuestManager.has_signal("aura_updated"):
			QuestManager.aura_updated.connect(_apply_aura_effects)
	
	_apply_aura_effects("") # Początkowe przeliczenie
	
func _apply_aura_effects(_name):
	current_speed = speed
	
	print("--- PRZELICZANIE AUR ---")
	print("Aktywne aury w Managerze: ", QuestManager.active_auras)
	
	if QuestManager.has_aura("Percepcja_Romana"):
		current_speed += 20
	
	if QuestManager.has_aura("Pomocna_Dlon"):
		current_speed += 20
		
	if QuestManager.has_aura("blogoslawienstwo_wojtka"):
		current_speed += 20
		print("ESSA! Doliczono błogosławieństwo Wojtka.")
		
		
	print("Aktualna prędkość: ", current_speed)



func _on_area_entered(area):
	var parent = area.get_parent()
	if parent is Interactable:
		interactables_in_range.append(parent)
		#interaction_ui.show_prompt(parent.interaction_text)
		update_current_interactable()



func _on_area_exited(area):
	var parent = area.get_parent()
	if parent in interactables_in_range:
		interactables_in_range.erase(parent)
	
	#if interactables_in_range.is_empty():
		#interaction_ui.hide_prompt()
	update_current_interactable()


func update_current_interactable():
	if current_interactable:
		current_interactable.set_highlight(false)
	
	if interactables_in_range.is_empty():
		current_interactable = null
		interaction_ui.hide_prompt()
		return
	
	# Get closest
	var closest = interactables_in_range[0]
	var closest_distance = global_position.distance_to(closest.global_position)
	
	for obj in interactables_in_range:
		var distance = global_position.distance_to(obj.global_position)
		if distance < closest_distance:
			closest = obj
			closest_distance = distance
	
	current_interactable = closest
	current_interactable.set_highlight(true)
	interaction_ui.show_prompt(current_interactable.interaction_text)

func _process(delta: float):
	update_velocity()
	move_and_slide()
	if Input.is_action_just_pressed("interact"):
		interact()

func update_velocity():
	# Reset moving_direction
	moving_direction.x = 0
	moving_direction.y = 0
	
	# Set direction based on currently pressed keys
	if Input.is_action_pressed("ui_right"):
		moving_direction.x += 1
		last_moving_direction = Vector2.RIGHT
	if Input.is_action_pressed("ui_left"):
		moving_direction.x -= 1
		last_moving_direction = Vector2.LEFT
	if Input.is_action_pressed("ui_down"):
		moving_direction.y += 1
		last_moving_direction = Vector2.DOWN
	if Input.is_action_pressed("ui_up"):
		moving_direction.y -= 1
		last_moving_direction = Vector2.UP
	
	# Normalize and apply speed
	velocity = moving_direction.normalized() * current_speed	
 	# Update animation
	update_animation()


func update_animation():
	if animated_sprite == null:
		return
	
	# Determine if character is moving
	var is_moving = velocity.length() > 0.1  # Small threshold to avoid jitter

	# Set animation based on movement
	if is_moving:
		# Handle movement animations
		if abs(velocity.x) > abs(velocity.y):
			# Horizontal movement
			animation_direction = "move_right" if last_moving_direction.x > 0 else "move_left"
		else:
			# Vertical movement
			animation_direction = "move_front" if last_moving_direction.y > 0 else "move_back"
	else:
		# Handle idle animations
		if abs(last_moving_direction.x) > abs(last_moving_direction.y):
			# Horizontal movement
			animation_direction = "idle_right" if last_moving_direction.x > 0 else "idle_left"
		else:
			# Vertical movement
			animation_direction = "idle_front" if last_moving_direction.y > 0 else "idle_back"
	
	# Play the animation
	animated_sprite.play(animation_direction)
	
	
	
func interact():
	if interactables_in_range.is_empty():
		return
	
	# Get closest interactable
	var closest = interactables_in_range[0]
	var closest_distance = global_position.distance_to(closest.global_position)
	
	for obj in interactables_in_range:
		var distance = global_position.distance_to(obj.global_position)
		if distance < closest_distance:
			closest = obj
			closest_distance = distance
	
	closest.interact(self)
	
func add_item(item: ItemData):
	inventory.append(item)
	print(inventory)
	print("Picked up: ", item.item_name)
	inventory_updated.emit()
