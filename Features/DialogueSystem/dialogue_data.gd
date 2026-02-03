class_name DialogueData

#---------------------------------------------------------------------------------------------------
var text : String = ""
var speaker_name : String = ""
var next_dialogue_tag : String = ""
var responses : Array = [] # Contains dialogue data
var enabled : bool = true # Used to disable responses
var raw_data : Dictionary


#---------------------------------------------------------------------------------------------------
func _init(dialogue_json: Dictionary) -> void:
	raw_data = dialogue_json
	
	text = dialogue_json["text"]
	next_dialogue_tag = dialogue_json.get("next_dialogue_tag", "")
	
	var responses_json = dialogue_json.get("responses", [])
	for entry in responses_json:
		responses.append(DialogueData.new(entry))


#---------------------------------------------------------------------------------------------------
func has_valid_response() -> bool:
	for response : DialogueData in responses:
		if response.enabled:
			return true
			
	return false


#---------------------------------------------------------------------------------------------------
