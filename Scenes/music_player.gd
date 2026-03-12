# MusicPlayer.gd
extends AudioStreamPlayer

# Słownik z Twoimi utworami
var tracks = {
	"default": preload("res://Assets/Audio/metin2-bg.mp3"),
	"akcja": preload("res://Assets/Audio/hs-walka.mp3"),
	"piotr": preload("res://Assets/Audio/hs-intro.mp3"),
	"szkola": preload("res://Assets/Audio/Wiazanka na sto lat.mp3")
}

func play_track(track_name: String):
	if tracks.has(track_name):
		var target_stream = tracks[track_name]
		
		if stream == target_stream and playing:
			return 
			
		print("MusicPlayer: Zmieniam utwór na: ", track_name) # DEBUG
		stream = target_stream
		play()
	else:
		print("MusicPlayer BŁĄD: Nie znaleziono utworu: ", track_name)
			
		# Jeśli utwór jest inny, zmieniamy go i puszczamy od nowa
		
