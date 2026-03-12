@tool
extends EditorScript

func _run():
	var dirs = ["res://Resources/NPC_Profiles/", "res://Resources/Dialogs/Internal/"]
	for d in dirs: DirAccess.make_dir_recursive_absolute(d)

	var npcs_to_build = {
		"Wojtek": {
			"profile_path": "res://Resources/NPC_Profiles/Wojtek_Profile.tres",
			"entries": [
				{
					"id": "start", "quest": "", "status": "",
					"json": '[
						{
							"text": "O nie! Zaraz minie 24h od postu! O siema Wiktor! Masz chwilę? Przydałaby mi się twoja pomoc.",
							"choices": [
								{
									"text": "No dobra, o co chodzi?", 
									"action": {
										"start_quest": "Przylap_Szweda_na_goracym_uczynku",
										"quest_desc": "Ciekawe czy i tym razem chujowo zaparkował…"
									},
									"next_line": 2
								},
								{"text": "Pal gumsona łysy.", "next_line": 1}
							]
						},
						{ "text": "O dobra, dzięki, ty też pal gumę. Essa!", "choices": [{"text": "...", "next_line": -1}] },
						{
							"text": "Szwedzik pewnie znowu chujowo zaparkował. Zdobądź dla mnie zdjęcie jego auta.",
							"choices": [
								{
									"text": "Tak się składa, że mam je! Patrz na to!", 
									"requires": {"item": "Zdjecie"},
									"next_line": 3
								},
								{"text": "Pewnie już się za to biorę.", "next_line": -1}
							]
						},
						{
							"text": "Hahahahahaha, idealnie! [Za pomoc otrzymujesz Talon i aurę]",
							"choices": [
								{
									"text": "[Akceptuj]",
									"action": {
										"remove_item": "Zdjecie",
										"add_item": "res://Resources/Items/Talon.tres",
										"add_aura": "blogoslawienstwo_wojtka",
										"complete_quest": "Przylap_Szweda_na_goracym_uczynku",
										"complete_desc": "Wciąż mnie to zadziwia że można tak źle parkować, może mu brakuje czegoś więcej niż palców."
									},
									"next_line": -1
								}
							]
						}
					]'
				},
				{
					"id": "waiting", "quest": "Przylap_Szweda_na_goracym_uczynku", "status": "started",
					"json": '[
						{
							"text": "I co udało Ci się zdobyć zdjęcie?",
							"choices": [
								{
									"text": "Nie uwierzysz! Mam je!", 
									"requires": {"item": "Zdjecie"},
									"next_line": 1
								},
								{"text": "jeszcze nie...", "next_line": 2}
							]
						},
						{
							"text": "Hahahahahaha, idealnie! [Za pomoc otrzymujesz Talon i aurę]",
							"choices": [
								{
									"text": "[Akceptuj]",
									"action": {
										"remove_item": "Zdjecie",
										"add_item": "res://Resources/Items/Talon.tres",
										"add_aura": "blogoslawienstwo_wojtka",
										"complete_quest": "Przylap_Szweda_na_goracym_uczynku",
										"complete_desc": "Wciąż mnie to zadziwia że można tak źle parkować, może mu brakuje czegoś więcej niż palców."
									},
									"next_line": -1
								}
							]
						},
						{
							"text": "Pal gumę i rób to zdjęcie!",
							"choices": [{"text": "Essa!", "next_line": -1}]
						}
					]'
				},
				{
					"id": "after_quest", "quest": "Przylap_Szweda_na_goracym_uczynku", "status": "completed",
					"json": '[
						{
							"text": "[klik klik] Nie przeszkadzaj mi teraz, dodaję post. Pal gumę.",
							"choices": [{"text": "Essa.", "next_line": -1}]
						}
					]'
				}
			]
		}
	}

	for name in npcs_to_build:
		_build_profile(name, npcs_to_build[name])

func _build_profile(npc_name, data):
	var profile = load("res://NPCProfile.gd").new()
	profile.npc_name = npc_name
	for e in data["entries"]:
		var d_res = DialogueData.new()
		d_res.npc_name = npc_name
		d_res.lines = JSON.parse_string(e["json"])
		var d_path = "res://Resources/Dialogs/Internal/" + npc_name + "_" + e.id + ".tres"
		ResourceSaver.save(d_res, d_path)
		var entry = load("res://NPCDialogueEntry.gd").new()
		entry.dialogue = load(d_path)
		entry.required_quest = e["quest"]
		entry.required_status = e["status"]
		profile.dialogues.append(entry)
	ResourceSaver.save(profile, data["profile_path"])
	print("Zaktualizowano profil: ", npc_name)
