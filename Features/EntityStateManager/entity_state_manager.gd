extends Node

@export var base_character_data_file: String = "res://Content/Characters/base_character_data.json"

# NPC state data
var _state_data: Dictionary = {} ## E.g. { "daisy": { "is_thirsty": true, "affection_score": 0 } }


func _ready() -> void:
	# Load dialogue from a file (JSON) at start-up.
	var file := FileAccess.open(base_character_data_file, FileAccess.READ)
	if file:
		_state_data = JSON.parse_string(file.get_as_text()) as Dictionary
		file.close()


func get_next_dialogue_tag(npc_tag: String) -> String:
	var npc_data = _state_data.get(npc_tag, {})
	var dialogue_tag = npc_data.get("next_dialogue_tag", "")
	
	if dialogue_tag == "":
		print_debug("Invalid NPC tag or incorrect data")

	return dialogue_tag


func set_next_dialogue_tag(npc_tag: String, dialogue_tag: String) -> void:
	_state_data[npc_tag]["next_dialogue_tag"] = dialogue_tag


## Sets a state variable for an NPC.
func set_field(npc_tag: String, field_name: String, value) -> void:
	"""Set a field for this NPC's state and invalidate cache if necessary."""
	if not _state_data.has(npc_tag):
		_state_data[npc_tag] = {}
	_state_data[npc_tag][field_name] = value


## Retrieves a set of tags for an NPC by evaluating its state.
func get_tags(npc_tag: String) -> Array:
	
	# Resolve NPC's state into a set of tags.
	if not _state_data.has(npc_tag):
		_state_data[npc_tag] = {}
	var state : Dictionary = _state_data[npc_tag]

	# Converts from values to parsable text tags (essentially booleans)
	var tags := []
	if state.get("is_thirsty", false):
		tags.push_back("is_thirsty")
	if state.get("affection_score", 0) > 5:
		tags.push_back("is_happy")
	return tags
