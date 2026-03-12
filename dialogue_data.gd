extends Resource
class_name DialogueData

@export var npc_name: String
@export var lines: Array = []


# Example line format:
# {
#   "text": "Hello, traveler!",
#   "choices": [
#       {"text": "Hi!", "next_line": 1},
#       {"text": "Leave me alone.", "next_line": -1}
#   ]
# }
# - "next_line": -1 means end dialogue


# Przykład linii z zadaniem
#{
  #"text": "Witaj! Czy możesz przynieść mi Jabłko?",
  #"choices": [
	#{
	  #"text": "Oczywiście, pomogę!", 
	  #"next_line": 1,
	  #"action": {"start_quest": "Jablkowa_Misja"}
	#},
	#{
	  #"text": "Mam jabłko tutaj!", 
	  #"next_line": 2,
	  #"requires": {"item": "Apple", "quest_status": ["Jablkowa_Misja", "started"]},
	  #"action": {"remove_item": "Apple", "complete_quest": "Jablkowa_Misja", "give_flag": "npc1_zadowolony"}
	#}
  #]
#}
