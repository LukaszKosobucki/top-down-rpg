@tool
extends EditorScript

func _run():
	var dirs = ["res://Resources/NPC_Profiles/", "res://Resources/Dialogs/Internal/"]
	for d in dirs: DirAccess.make_dir_recursive_absolute(d)

	var npcs_to_build = {
		"Piotr": {
			"profile_path": "res://Resources/NPC_Profiles/Piotr_Profile.tres",
			"entries": [
				{
					"id": "rage_intro", "quest": "", "status": "",
					"json": '[
						{
							"text": "[JEB JEB JEB] Koleś ma prep, prep, vanish, vanish, dzik, cofnięcie, cofnięcie, cofnięcie, cofnięcie, cofnięcie dwadzieścia kart do wyciągnięcia. DWADZIEŚCIA K*RWA KART! PO CH*J JEST TAM DWADZIEŚCIA KART JAK TY MASZ DZIESIĘĆ I WYGRYWASZ GRĘ W CZWARTEJ TURZE K*RWA STO RAZY NA STO RAZY?!",
							"action": { "play_music": "piotr" },
							"choices": [
								{"text": "Spokojnie Piotr, to tylko gra...", "next_line": 1}
							]
						},
						{
							"text": "CZY KOGOŚ POJEBAŁO TUTAJ? TO JEST OSZUSTWO JA DWA DO JEDEN PRZEGRYWAM ALBO WYGRYWAM DWADZIEŚCIA K*RWA GIER Z RZĘDU, NO NIE MOGĘ PO PROSTU! Ja K*RWA nie mam czasu grać na gościa który rogalem wygrywa w czwartej turze k*rwa?! Przez k*rwa jedyne dziesięć kart w decku na sto do wyciągnięcia?!",
							"choices": [
								{"text": "Piotr, ręka Ci krwawi...", "next_line": 2}
							]
						},
						{
							"text": "Ała k*rwa rzeczywiście, Nastał nie rozpraszaj mnie! Nie widzisz że legendę tutaj wbijam?!",
							"choices": [
								{"text": "Pal gumę, essa.", "next_line": -1}
							]
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
