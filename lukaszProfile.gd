@tool
extends EditorScript

func _run():
	var dirs = ["res://Resources/NPC_Profiles/", "res://Resources/Dialogs/Internal/"]
	for d in dirs: DirAccess.make_dir_recursive_absolute(d)

	var npcs_to_build = {
		"Łukasz": {
			"profile_path": "res://Resources/NPC_Profiles/Lukasz_Profile.tres",
			"entries": [
				{
					"id": "start", "quest": "", "status": "",
					"json": '[
						{
							"text": "Tym razem na pewno zdąże na Pierwszą lekcję! O nie! zapomniałem śniadania! Wzywam łódź podwodną! O cześć Wiktor! Nastał na Ciebie czas! Mógłbyś ode mnie przekazać Mariuszkowi że mogę się spóźnić na lekcje? Na pewno zrozumie. W końcu daleko mieszkam",
							"choices": [
								{"text": "Pewnie.", "next_line": 2},
								{"text": "Pal gumę.", "next_line": 1}
							]
						},
						{
							"text": "Pal gumę nastałson.",
							"choices": [{"text": "...", "next_line": -1}]
						},
						{
							"text": "Super jesteś Wiktor dzięki! W ogóle dzisiaj mamy pracę w grupach na fizyce, może usiądziemy razem terapią? Tylko wszyscy chorzy poza Wolską, pójdziesz spytać się jej czy by chciała terapiowo usiąść?",
							"choices": [
								{
									"text": "Bardzo dobry pomysł, już lecę, tylko się nie spóźnij pajacu!", 
									"action": {
										"start_quest": "Terapia_reunited",
										"quest_desc": "Znajdź i pogadaj z Kają"
									},
									"next_line": -1
								},
								{"text": "BOŻE, znowu z tobą w grupie… nie dzięki.", "next_line": -1}
							]
						}
					]'
				},
				{
					"id": "waiting", "quest": "Terapia_reunited", "status": "started",
					"json": '[
						{
							"text": "No gdzie ta łódź podwona, muszę się dostać do piekarni po chałkę, znowu się spóźnię Kurwica.",
							"choices": [{"text": "Pajac...", "next_line": -1}]
						}
					]'
				},
				{
					"id": "after", "quest": "Terapia_reunited", "status": "completed",
					"json": '[
						{
							"text": "No gdzie ta łódź podwona, muszę się dostać do piekarni po chałkę, znowu się spóźnię Kurwica.",
							"choices": [{"text": "Pajac...", "next_line": -1}]
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
