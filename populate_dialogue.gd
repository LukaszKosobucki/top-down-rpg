@tool
extends EditorScript

func _run():
	var dirs = ["res://Resources/NPC_Profiles/", "res://Resources/Dialogs/Internal/"]
	for d in dirs: DirAccess.make_dir_recursive_absolute(d)

	var npcs_to_build = {
		"Patryk": {
			"profile_path": "res://Resources/NPC_Profiles/Patryk_Profile.tres",
			"entries": [
				{
					"id": "start", "quest": "", "status": "",
					"json": '[
						{
							"text": "Jdjsbajajevu WIktor! WIKTOR Co z Ciebie wyrośnie Kawosz na mleku czy skejt na sośnie! CO robisz tak szybko in SQL?!?!? Ja na Twoim miejscu minute przed czasem bym skakał z okna i wklatywał tu na paralotni ale nie może żyć za Ciebie. Ja jak widzisz niestety też musiałem sie zmaterializować szybciej ale zużyło to całą moją energie, uratować mnie może tylko całus od Martyny której dziś nie ma w szkole nie szukaj jej lub coś NAPRAWDE SMERFASTYCZNEGO do jedzenia nie żadne zwykłe ciastko na kiju.",
							"choices": [
								{"text": "Dobrze dzisiaj spałem, może mogę Ci jakoś pomóc z twoim głodem?", "next_line": 1},
								{"text": "Bywaj", "next_line": -1}
							]
						},
						{
							"text": "Gość sie mnie pyta czy może mi pomóc z głodem trzymajcie mnie! Wiktor wybuchnę z głodu za jakieś 5 sekund a gość sie pyta czy może mi pomóc nie no zgrywam sie misiu, będę ekstremalnie wdzięczny jeśli dasz mi najaksamitniejszy smak błogości zamknięty w ciastku które zaoferuje Ci największy Polak jaki chodził po tej ziemi... SPOILER: NIE CHODZI O MNIE ANI O MARIUSZA PUDZIANA.",
							"choices": [
								{
									"text": "Pewnie", 
									"action": {
										"start_quest": "Nakarm_BESTIE",
										"quest_desc": "Patryk wydawał się głodny, muszę poszukać czegoś słodkiego dla niego ZANIM ZGINIE Z GŁODU."
									},
									"next_line": -1
								},
								{"text": "wiesz co nie mam czasu, spytaj mnie o to później", "next_line": -1}
							]
						}
					]'
				},
				{
					"id": "waiting", "quest": "Nakarm_BESTIE", "status": "started",
					"json": '[
						{
							"text": "Patryk: I co JESTEŚ GOTOWY NAKARMIĆ BESTIE? Czy załatwiłeś mi już GIGATURBO ZASMERFASTYCZNE CIASTKO 5000 od sam wiesz kogo? Nie?, w takim razie nie mam siły z Tobą gadać naraaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
							"choices": [{"text": "jeszcze nie... Daj mi chwilę.", "next_line": -1}]
						}
					]'
				},
				{
					"id": "waiting_alt", "quest": "Nakarm_BESTIE", "status": "szukanie_dziewczynki",
					"json": '[{"text": "Smerfuj szybciej Wiktor! Widzę już białe światło!", "choices": [{"text": "Daj mi moment!", "next_line": -1}]}]'
				},
				{
					"id": "hand_in", "quest": "Nakarm_BESTIE", "status": "kremowka_zdobyta",
					"json": '[
						{
							"text": "Uuuuxuhsbakdbsidjs WIDZĘ mchdjzusn ŻE cjdhdbsusis MASZ djdhdush DLA hxjwhshs MNIE fnjsudsu COŚ.",
							"choices": [
								{"text": "Tak mam dla Ciebie kremówkę prosto z Wadowic jeszcze ciepła chcesz ją?", "next_line": 1}
							]
						},
						{
							"text": "TAAAAAJXHXBSHXHDKKKKK DAWAJ DAJ MI JĄ ZAPŁACĘ ZAPŁACE 300 SZTUK ZŁOTA ZA KAŻDE JAJO znaczy sie kremówkę",
							"choices": [
								{
									"text": "Trzymaj (Oddaj kremówkę)", 
									"requires": {"item": "Kremowka"},
									"next_line": 2
								},
								{"text": "wiesz co dzięki ale chyba sie rozmyśliłem, sam ją zjem zachowaj swoje złoto i idź poszukaj Martyny.", "next_line": -1}
							]
						},
						{
							"text": "[otrzymujesz w nagrodę aurę pomocna dłoń, twoja predkość ruchu rośnie o 50%]",
							"choices": [
								{
									"text": "[akceptuj]",
									"action": {
										"remove_item": "Kremowka",
										"add_aura": "Pomocna_Dlon",
										"complete_quest": "Nakarm_BESTIE",
										"complete_desc": "Dostałeś aurę Pomocna Dłoń - Patryk przybędzie Ci na ratunek!"
									},
									"next_line": -1
								}
							]
						}
					]'
				},
				{
					"id": "finished", "quest": "Nakarm_BESTIE", "status": "completed",
					"json": '[{
						"text": "OBOŻE ALE TO BYŁA DOBRA KREMÓWKA OMNOMNOMNOM",
						"choices": [{"text": "Smakuwa!", "next_line": -1}]
					}]'
				}
			]
		},
		"JP_II": {
			"profile_path": "res://Resources/NPC_Profiles/JP_II_Profile.tres",
			"entries": [
				{
					"id": "default", "quest": "", "status": "",
					"json": '[{
						"text": "Habemus papam młody człowieku:",
						"choices": [{"text": "[spesz się i odejdź w pośpiechu]", "next_line": -1}]
					}]'
				},
				{
					"id": "intro", "quest": "Nakarm_BESTIE", "status": "started",
					"json": '[
						{
							"text": "NIECH BĘDZIE POCHWALONY młodzieńcu, piękny macie ten Bolesławiec! Czy w czymś Ci pomóc?",
							"choices": [
								{"text": "O BOŻE PAPIEŻAK ZŁOTY. Co ty tu robisz obok szkoły?", "next_line": 1},
								{"text": "To na pewno się nie dzieje naprawdę, idę stąd.", "next_line": -1}
							]
						},
						{
							"text": "Haha a co mogę robić obok szkoły? co to za naiwne pytania? PRZYSZEDŁEM MODLIĆ SIE ZA DUSZE WSZYSTKICH ZBŁĄKANYCH DUSZYCZEK",
							"choices": [
								{"text": "No tak... Moj przyjaciel jest bardzo głodny, a widze że pracujesz dzisiaj za kasą w kremówkowni.", "next_line": 2}
							]
						},
						{
							"text": "Jeszcze jak! chcesz dostać kremówkę?",
							"choices": [
								{"text": "Tak, daj, daj, dam Ci 300 sztuk złota!", "next_line": 3}
							]
						},
						{
							"text": "HAHA Nie dla psa polaka to! Przynieś mi Dziewczynkę z warkoczykami lub bez warkoczyków a dostaniesz ode mnie krewmówkę!",
							"choices": [
								{
									"text": "Przyjmuję to zadanie, dla Patryka je zdobędę!", 
									"action": {
										"update_status": {"id": "Nakarm_BESTIE", "value": "szukanie_dziewczynki"},
										"update_desc": {"id": "Nakarm_BESTIE", "value": "Muszę znaleźć dziewczynkę z warkoczykami lub bez warkoczyków żeby Papieżak mi dał kremówkę."}
									},
									"next_line": -1
								},
								{"text": "przemyślę to", "next_line": -1}
							]
						}
					]'
				},
				{
					"id": "waiting_item", "quest": "Nakarm_BESTIE", "status": "szukanie_dziewczynki",
					"json": '[
						{
							"text": "I co uczniaku? masz już dla mnie Dziewczynkę z warkoczykami lub bez warkoczyków?",
							"choices": [
								{
									"text": "mam! proszę o to dziewczynkę z warkoczykami lub bez warkoczyków", 
									"requires": {"item": "Dziewczynka", "count": 1},
									"action": {
										"remove_item": "Dziewczynka", "count": 1,
										"add_item": "res://Resources/Items/Kremowka.tres",
										"update_status": {"id": "Nakarm_BESTIE", "value": "kremowka_zdobyta"},
										"update_desc": {"id": "Nakarm_BESTIE", "value": "Zdobyłeś Kremówkę dla Patryka. Śpiesz sie żeby go nakarmić!"}
									},
									"next_line": -1
								},
								{"text": "jeszcze nie.... Idę dalej szukać.", "next_line": -1}
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
