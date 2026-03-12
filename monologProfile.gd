@tool
extends EditorScript

func _run():
	var data = {
		"Wiktor_Intro": {
			"profile_path": "res://Resources/NPC_Profiles/Wiktor_Intro.tres",
			"entries": [
				{
					"id": "intro", "quest": "", "status": "",
					"json": '[
						{
							"text": "Co tu się dzieje... przed chwilą kładłem się spać, żeby jutro wstać do pracy na PWR... orkopieństwo. A teraz jestem gdzieś indziej? Co to za ubranie na mnie? To wszystko wygląda znajomo... czuję dużą potrzebę pójścia do szkoły...",
							"choices": [{"text": "....", "next_line": -1}],
							"action": { 
								"start_quest": "Dojscie_do_szkoly", 
								"quest_desc": "Muszę wejść do szkoły i rozejrzeć się." 
							}
						}
					]'
				}
			]
		}
	}

	for name in data:
		var profile = load("res://NPCProfile.gd").new()
		profile.npc_name = "Wiktor"
		var e = data[name]["entries"][0]
		var d_res = DialogueData.new()
		d_res.npc_name = "Wiktor"
		d_res.lines = JSON.parse_string(e["json"])
		var d_path = "res://Resources/Dialogs/Internal/Wiktor_intro_data.tres"
		ResourceSaver.save(d_res, d_path)
		
		var entry = load("res://NPCDialogueEntry.gd").new()
		entry.dialogue = d_res
		profile.dialogues.append(entry)
		ResourceSaver.save(profile, data[name]["profile_path"])
		print("Wygenerowano monolog startowy z questem.")
