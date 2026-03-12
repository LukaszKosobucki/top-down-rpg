@tool
extends EditorScript

func _run():
	var d_res = DialogueData.new()
	d_res.npc_name = "Wszyscy"
	d_res.lines = [
		{
			"text": "Wszyscy: ♪ Sto lat, sto lat, niech żyje, żyje nam! ♪",
			"choices": [{"text": "Dalej...", "next_line": 1}]
		},
		{
			"text": "Wszyscy: ♪ Sto lat, sto lat, niech żyje, żyje nam! ♪",
			"choices": [{"text": "Dalej...", "next_line": 2}]
		},
		{
			"text": "Wszyscy: ♪ Jeszcze raz, jeszcze raz, niech żyje, żyje nam! ♪",
			"choices": [{"text": "Dalej...", "next_line": 3}]
		},
		{
			"text": "To był piękny sen, i piękne czasy, ale czas wrócić do równie pięknej rzeczywistości. Podcast kawowy sam się nie nagra.",
			"choices": [
				{
					"text": "Zakończ sen", 
					"next_line": -1, 
					"action": {"end_game": true} # Zmieniamy na end_game dla lepszej kontroli
				}
			]
		}
	]
	
	ResourceSaver.save(d_res, "res://Resources/Dialogs/Internal/sto_lat.tres")
	print("Zaktualizowano sto_lat.tres z akcją end_game.")
