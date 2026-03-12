@tool
extends EditorScript

func _run():
	var dirs = ["res://Resources/NPC_Profiles/", "res://Resources/Dialogs/Internal/"]
	for d in dirs: DirAccess.make_dir_recursive_absolute(d)

	var npcs_to_build = {
		"Kaja": {
			"profile_path": "res://Resources/NPC_Profiles/Kaja_Profile.tres",
			"entries": [
				{
					"id": "default", "quest": "", "status": "",
					"json": '[
						{
							"text": "[Pali fajkę] Cześć Wiktor! Co dzisiaj robisz?",
							"choices": [{"text": "idę do szkoły, mogłabyś w końcu przestać cmolić te faje…", "next_line": -1}]
						}
					]'
				},
				{
					"id": "quest_active", "quest": "Terapia_reunited", "status": "started",
					"json": '[
						{
							"text": "[Pali fajkę] Cześć Wiktor! Co dzisiaj robisz?",
							"choices": [
								{"text": "idę do szkoły, mogłabyś w końcu przestać cmolić te faje…", "next_line": -1},
								{"text": "Gadałem z Bucem, mówił że dzisiaj praca w grupach na fizyce, siadamy grupowo terapią?", "next_line": 1}
							]
						},
						{
							"text": "OOO ale super pomysł! Mogę usiąść obok Ciebie?",
							"choices": [
								{"text": "Jak wywietrzejesz z fajek to tak…", "next_line": -1},
								{"text": "Nomć.", "next_line": 2}
							]
						},
						{
							"text": "Aleee suuper jesteś Wiiiiktor, podobał mi się twój ostatni filmik na yt, sama ostatnio myślałem żeby spróbować założyć swo kanał wiesz? Pomógłbyś mi po szkolę z tym?",
							"choices": [
								{"text": "W sumie i tak nie mam co robić, pewnie.", "next_line": 3}
							]
						},
						{
							"text": "Jesteś najlepszy Wiktor! Masz tutaj mój numer telefonu! Zadzwoń jak będziesz pod moją klatką to ci otworzę.",
							"choices": [
								{
									"text": "Dobra, dzięki", 
									"action": {
										"complete_quest": "Terapia_reunited",
										"complete_desc": "Kaja dzisiaj była dla mnie wyjątkowo miła, ciekawe co to może oznaczać… can’t really tell",
										"add_item": "res://Resources/Items/Numer.tres"
									},
									"next_line": -1
								}
							]
						}
					]'
				},
				{
					"id": "after_quest", "quest": "Terapia_reunited", "status": "completed",
					"json": '[
						{
							"text": "Do zobaczenia po szkole Wiiiiiktoooorkuuuuu.",
							"choices": [{"text": "Essa…", "next_line": -1}]
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
