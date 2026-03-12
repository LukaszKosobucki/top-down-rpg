@tool
extends EditorScript

func _run():
	var dirs = ["res://Resources/NPC_Profiles/", "res://Resources/Dialogs/Internal/"]
	for d in dirs: DirAccess.make_dir_recursive_absolute(d)

	var npcs_to_build = {
		"Roman": {
			"profile_path": "res://Resources/NPC_Profiles/Roman_Profile.tres",
			"entries": [
				{
					"id": "start", "quest": "", "status": "",
					"json": '[
						{
							"text": "Cześć Wiktor, dobrze że jesteś, właśnie zastanawiałem się nad trasncendencją modularności dwojakości czasoprzestrzeni w płaszczyźnie urojonej...",
							"choices": [
								{"text": "Jo dupio, brzmi poważnie co to za eksperyment?", "next_line": 2},
								{"text": "Wiesz co, wrócę może później, jak otrzeźwiejesz.", "next_line": 1}
							]
						},
						{
							"text": "Wiedziałem że to powiesz.",
							"choices": [{"text": "....", "next_line": -1}]
						},
						{
							"text": "Wiedziałem że to powiesz. Zagrajmy w kamień papier nożyce.",
							"choices": [
								{"text": "Nie mam czasu na głupie gierki.", "next_line": 1},
								{
									"text": "Podejmuje się wyzwania, nigdy nie przegrałem.", 
									"action": {
										"start_quest": "Eksperyment_Romana", 
										"quest_desc": "Roman twierdzi, że zna przyszłość. Muszę go pokonać w KPN.",
										"play_music": "akcja"
									},
									"next_line": 3
								}
							]
						},
						{
							"text": "Wiedziałem że to powiesz. Aktualny wynik {roman_score}:{player_score} dla Romana. Wybierz symbol:",
							"choices": [
								{"text": "[Kamień]", "action": {"set_player_move": "Kamień", "calculate_rps": true}, "next_line": 4},
								{"text": "[Papier]", "action": {"set_player_move": "Papier", "calculate_rps": true}, "next_line": 4},
								{"text": "[Nożyce]", "action": {"set_player_move": "Nożyce", "calculate_rps": true}, "next_line": 4}
							]
						},
						{ "text": "3", "choices": [{"text": "...", "next_line": 5}] },
						{ "text": "2", "choices": [{"text": "...", "next_line": 6}] },
						{ "text": "1", "choices": [{"text": "...", "next_line": 7}] },
						{
							"text": "Roman: {roman_move}\\nWiktor: {player_move}",
							"choices": [{"text": "...", "next_line": 8}]
						},
						{
							"text": "HA! Wygrałem, to nie kwestia farta! Chcesz spróbować jeszcze raz?",
							"choices": [
								{
									"text": "Tak! Tym razem Cie na pewno pokonam", 
									"action": {"play_music": "akcja"},
									"next_line": 3
								},
								{"text": "Odnioslem porażkę.", "next_line": 9}
							]
						},
						{
							"text": "Wiedziałem że to powiesz. Sekretem jest odpowiednie stężenie kremówkozy papieskiej w organiźmie.",
							"choices": [{"text": "Chyba jednak jesteś pijany.", "next_line": 10}]
						},
						{
							"text": "[Wiedza tajemna od Romana zwieksza twoją percepcję rzeczywistości, poruszasz się 50% szybciej]",
							"choices": [
								{
									"text": "[Zamknij]", 
									"action": {
										"add_aura": "Percepcja_Romana",
										"complete_quest": "Eksperyment_Romana",
										"complete_desc": "Poznałeś tajemnicę Romana... i kremówkozy."
									},
									"next_line": -1
								}
							]
						}
					]'
				},
				{
					"id": "after_quest", "quest": "Eksperyment_Romana", "status": "completed",
					"json": '[
						{
							"text": "hmmmm transcendencja…. modularność… hmmmm Epstein.. znaczy Gauss. O cześć! gotowy na kolejną bitkę?",
							"choices": [
								{"text": "Tak", "action": {"play_music": "akcja"}, "next_line": 1},
								{"text": "Jesteś dla mnie za dobry.", "next_line": 8}
							]
						},
						{
							"text": "Aktualny wynik {roman_score}:{player_score} dla Romana. Wybierz symbol:",
							"choices": [
								{"text": "[Kamień]", "action": {"set_player_move": "Kamień", "calculate_rps": true}, "next_line": 2},
								{"text": "[Papier]", "action": {"set_player_move": "Papier", "calculate_rps": true}, "next_line": 2},
								{"text": "[Nożyce]", "action": {"set_player_move": "Nożyce", "calculate_rps": true}, "next_line": 2}
							]
						},
						{ "text": "3", "choices": [{"text": "...", "next_line": 3}] },
						{ "text": "2", "choices": [{"text": "...", "next_line": 4}] },
						{ "text": "1", "choices": [{"text": "...", "next_line": 5}] },
						{
							"text": "Roman: {roman_move}\\nWiktor: {player_move}",
							"choices": [{"text": "...", "next_line": 6}]
						},
						{
							"text": "HA! Wygrałem, to nie kwestia farta! Chcesz spróbować jeszcze raz?",
							"choices": [
								{"text": "Tak!", "action": {"play_music": "akcja"}, "next_line": 1},
								{"text": "Odniosłem porażkę.", "next_line": 7}
							]
						},
						{
							"text": "Wiedziałem że to powiesz.",
							"choices": [{"text": "....", "next_line": -1}]
						},
						{
							"text": "Wiedziałem że to powiesz.",
							"choices": [{"text": "... świrus.", "next_line": -1}]
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
