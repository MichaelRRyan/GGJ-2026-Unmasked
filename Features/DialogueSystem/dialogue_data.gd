class_name DialogueData

var text : String = ""
var speaker_name : String = ""
var next_dialogue_tag : String = ""
var responses : Array = [] # Contains dialogue data?


func _init(dialogue_json: Dictionary) -> void:
	text = dialogue_json["text"]
	responses = dialogue_json.get("responses", [])
