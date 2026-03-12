@tool
extends EditorScript

func _run():
	var dirs = ["res://Resources/NPC_Profiles/", "res://Resources/Dialogs/Internal/"]
	for d in dirs: DirAccess.make_dir_recursive_absolute(d)

	var npcs_to_build = {
		"Szwed": {
			"profile_path": "res://Resources/NPC_Profiles/Szwed_Profile.tres",
			"entries": [
				{
					"id": "default", "quest": "", "status": "",
					"json": '[
						{
							"text": "Mmmm, tak, mmmm, szwedzkie sposoby parkowania, taaaaak.",
							"choices": [
								{
									"text": "... [zrób zdjęcie jak chujowo zaparkował]",
									"action": {
										"add_item": "res://Resources/Items/Zdjecie.tres",
										"give_flag": "zrobiono_zdjecie_szweda"
									},
									"next_line": 1
								}
							]
						},
						{
							"text": "*Klik!* Aparat uwiecznił ten kunszt parkowania. Szwed zdaje się tego nie zauważać, dalej podziwiając linię krawężnika.",
							"choices": [{"text": "Bywaj.", "next_line": -1}]
						}
					]'
				},
				{
					"id": "after_photo", "quest": "", "status": "",
					"json": '[
						{
							"text": "Taaaa, kąt nachylenia koła względem linii... poezja.",
							"choices": [{"text": "Mhm... jasne.", "next_line": -1}]
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
		
		# Dodatkowe sprawdzenie flagi, żeby nie robić zdjęcia 100 razy
		if e.id == "after_photo":
			entry.required_flag = "zrobiono_zdjecie_szweda"
			
		profile.dialogues.append(entry)
	
	ResourceSaver.save(profile, data["profile_path"])
	print("Zaktualizowano profil: ", npc_name)
