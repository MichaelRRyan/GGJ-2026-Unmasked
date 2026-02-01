extends Node
#class_name DialoguePicker

@export var dialogue_data_file: String = "res://Content/Dialogue/dialogue_data.json"

# Node references
@onready var _dialogue_interface: DialogueInterface = null

## Stores all dialogue for all NPCs.
var _dialogue_data: Dictionary = {}  ## { "daisy": [ { "conditions": [], "text": "…" } ] }

var _current_npc_tag = null
var _current_dialogue : DialogueData = null


#---------------------------------------------------------------------------------------------------
func _ready() -> void:
	# Load dialogue from a file (JSON) at start-up.
	var file := FileAccess.open(dialogue_data_file, FileAccess.READ)
	if file:
		_dialogue_data = JSON.parse_string(file.get_as_text()) as Dictionary
		file.close()


#----------------------------------------------------------------------------------------------------
func show_dialogue(entity_tag: String):
	if not _dialogue_interface.visible:
		var dialogue_data : DialogueData = _select_dialogue(entity_tag)
		_dialogue_interface.show_dialogue(dialogue_data)


#---------------------------------------------------------------------------------------------------
## Picks a piece of dialogue matching conditions.
func _select_dialogue(entity_tag: String) -> DialogueData:
	_current_npc_tag = entity_tag
	var dialogue_tag = EntityStateManager.get_next_dialogue_tag(entity_tag)
	var game_tags := []
	
	# Get the tags for the npc and world.
	game_tags.append_array(EntityStateManager.get_tags(entity_tag))
	game_tags.append_array(GameEventTracker.get_active_tags())
	
	# Selects the first dialogue with valid tags.
	var pool : Array = _dialogue_data.get(dialogue_tag, [])
	for entry in pool:
		var conditions : Array = entry.conditions
		
		if _matches(conditions, game_tags):
			_current_dialogue = DialogueData.new(entry)
			EntityStateManager.set_next_dialogue_tag(_current_npc_tag, _current_dialogue.next_dialogue_tag)
			
			# Apply any tags in the dialogue.
			var new_game_tags = entry.get("game_tags_to_add", [])
			for tag : String in new_game_tags:
				GameEventTracker.activate_event(tag)
				
			var new_entity_tags = entry.get("entity_tags_to_add", [])
			for tag : String in new_entity_tags:
				EntityStateManager.add_tag(entity_tag, tag)
			
			_debug_print_all_tags(entity_tag)
			
			return _current_dialogue
			
	return null  ## fallback


#---------------------------------------------------------------------------------------------------
func _debug_print_all_tags(entity_tag):
	var game_tags := []

	# Get the tags for the npc and world.
	game_tags.append_array(EntityStateManager.get_tags(entity_tag))
	game_tags.append_array(GameEventTracker.get_active_tags())
	
	print("All tags: " + str(game_tags) + " for entity [" + entity_tag + "]")


#---------------------------------------------------------------------------------------------------
# Called when a response option is pressed.
func option_selected(option_no : int) -> DialogueData:
	if option_no < _current_dialogue.responses.size():
		var response : DialogueData = _current_dialogue.responses[option_no]
		var next_dialogue_tag : String = response.next_dialogue_tag
				
		# Retrieve and set the next dialogue for this NPC based on the chosen dialogue.
		EntityStateManager.set_next_dialogue_tag(_current_npc_tag, next_dialogue_tag)
		
		# Replace this by calling the interface to display this.
		var next_dialogue = _select_dialogue(_current_npc_tag)
		return next_dialogue
	
	return null


#---------------------------------------------------------------------------------------------------
## Helper to match conditions against tags.
func _matches(conditions: Array, game_tags: Array) -> bool:
	
	# Return true if all conditions match the context.
	for condition : String in conditions:
		
		if condition.begins_with("!"):
			var raw_condition = condition.substr(1)
			if raw_condition in game_tags:
				return false
				
		elif not (condition in game_tags):
			return false
			
	return true


#---------------------------------------------------------------------------------------------------
