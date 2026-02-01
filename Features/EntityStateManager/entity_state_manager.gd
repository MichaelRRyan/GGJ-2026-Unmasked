extends Node

@export var base_character_data_file: String = "res://Content/Characters/base_character_data.json"

# NPC state data
var _state_data: Dictionary = {} ## E.g. { "daisy": { "is_thirsty": true, "affection_score": 0 } }

var bgm_player = AudioStreamPlayer.new()

func _setup_audio() -> void:
	add_child(bgm_player)
	print("loaded song")
	_select_audio()


func _select_audio():
	var current_path = get_tree().current_scene.scene_file_path
	if current_path == "res://Levels/level_bar.tscn":
		bgm_player.stream = load("res://Assets/Audio/unmasked_bar_theme.wav")
	elif current_path == "res://Levels/level_witch_tower.tscn":
		bgm_player.stream = load("res://Assets/Audio/unmasked_witch_theme.wav")
	elif current_path == "res://Levels/level_bakery.tscn": # Fixed logic here
		bgm_player.stream = load("res://Assets/Audio/unmasked_end_screen.wav")
	else: 
		bgm_player.stream = load("res://Assets/Audio/unmasked_theme.mp3")
	
	bgm_player.play(0.0)


func _ready() -> void:
	# Load dialogue from a file (JSON) at start-up.
	var file := FileAccess.open(base_character_data_file, FileAccess.READ)
	if file:
		_state_data = JSON.parse_string(file.get_as_text()) as Dictionary
		file.close()
	
	_setup_audio()
	get_tree().scene_changed.connect(_select_audio)


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


## Sets a state variable for an NPC.
func add_tag(entity_tag: String, tag: String) -> void:
	if not _state_data.has(entity_tag):
		_state_data[entity_tag] = {}
	
	if _state_data[entity_tag].has("raw_tags"):
		if not _state_data[entity_tag]["raw_tags"].has(tag):
			_state_data[entity_tag]["raw_tags"].append(tag)
			print("Entity tag [" + tag + "] added to [" + entity_tag + "]")
			
		else: 
			print("Entity tag [" + tag + "] not added to [" + entity_tag + "] - Already active")
	else:
		_state_data[entity_tag]["raw_tags"] = [tag]
		print("Entity tag [" + tag + "] added to [" + entity_tag + "]")


## Retrieves a set of tags for an NPC by evaluating its state.
func get_tags(npc_tag: String) -> Array:
	if not _state_data.has(npc_tag):
		return []
	return _resolve_tags(_state_data[npc_tag])


func _resolve_tags(state : Dictionary) -> Array:
	# Converts from values to parsable text tags (essentially booleans)
	var tags := []
	if state.get("is_thirsty", false):
		tags.push_back("is_thirsty")
	if state.get("affection_score", 0) > 5:
		tags.push_back("is_happy")
		
	tags.append_array(state.get("raw_tags", []))
	
	return tags
