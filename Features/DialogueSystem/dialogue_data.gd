class_name DialogueData

var text : String = ""
var speaker_name : String = ""
var next_dialogue_tag : String = ""
var responses : Array = [] # Contains dialogue data


func _init(dialogue_json: Dictionary) -> void:
	text = dialogue_json["text"]
	next_dialogue_tag = dialogue_json.get("next_dialogue_tag", "")
	
	var responses_json = dialogue_json.get("responses", [])
	for entry in responses_json:
		responses.append(DialogueData.new(entry))
