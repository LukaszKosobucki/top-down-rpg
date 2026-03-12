@tool
extends Interactable

# Przy zmianie tekstury lub profilu, od razu aktualizujemy wizualia
@export var npc_texture: Texture2D:
	set(value):
		npc_texture = value
		_refresh_visuals()

@export var npc_profile: NPCProfile:
	set(value):
		npc_profile = value
		_refresh_visuals()

@export var target_height: float = 32.0:
	set(value):
		target_height = value
		_refresh_visuals()

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var name_label: Label = $NameLabel

func _ready():
	_refresh_visuals()

func _refresh_visuals():
	# Tool mode check
	if sprite_2d == null: sprite_2d = get_node_or_null("Sprite2D")
	if name_label == null: name_label = get_node_or_null("NameLabel")
	
	if sprite_2d and npc_texture:
		sprite_2d.texture = npc_texture
		var current_tex_height = npc_texture.get_height()
		if current_tex_height > 0:
			var s = target_height / current_tex_height
			sprite_2d.scale = Vector2(s, s)
	
	if name_label:
		if npc_profile:
			name_label.text = npc_profile.npc_name
		else:
			name_label.text = "NPC"
		
		# KLUCZ DO WYCELOWANIA:
		# 1. Ustawiamy horyzontalne centrowanie tekstu
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		# 2. Resetujemy rozmiar labela, żeby dopasował się do tekstu
		name_label.size = Vector2.ZERO 
		
		# 3. POZYCJONOWANIE Y:
		# Jeśli pivot (punkt zero) Twojego NPC jest na ŚRODKU:
		name_label.position.y = -(target_height / 2) - 9
		# Jeśli pivot Twojego NPC jest na STOPACH (najczęstsze w RPG):
		# name_label.position.y = -target_height - 10 
		
		# 4. POZYCJONOWANIE X:
		# Przesuwamy o połowę szerokości labela w lewo, żeby jego środek był na osi 0
		name_label.position.x = -name_label.size.x / 2

# Reszta funkcji bez zmian...
func interact(player):
	if not npc_profile: 
		print("Błąd: NPC nie ma przypisanego profilu!")
		return
		
	var selected_dialogue = _get_best_dialogue()
	if selected_dialogue:
		var ui = get_tree().get_first_node_in_group("dialogue_ui")
		if ui:
			ui.start_dialogue(selected_dialogue, player)

func _get_best_dialogue() -> DialogueData:
	var best_fit: DialogueData = null
	for entry in npc_profile.dialogues:
		if not entry or not entry.dialogue: continue
		var quest_ok = true
		if entry.required_quest != "":
			quest_ok = QuestManager.get_quest_status(entry.required_quest) == entry.required_status
		var flag_ok = true
		if entry.required_flag != "":
			flag_ok = QuestManager.get_flag(entry.required_flag)
		if quest_ok and flag_ok:
			best_fit = entry.dialogue 
	return best_fit
