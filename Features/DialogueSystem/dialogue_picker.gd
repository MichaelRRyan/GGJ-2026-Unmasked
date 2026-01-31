extends Node
class_name DialoguePicker

@export var dialogue_data_file: String = "res://Content/Dialogue/dialogue_data.json"

# Node paths
@export var dialogue_interface_node: NodePath
@export var npc_state_manager_node: NodePath
@export var game_event_manager_node: NodePath

# Node references
@onready var _dialogue_interface: DialogueInterface = get_node(dialogue_interface_node)
@onready var npc_state_manager: NPCStateManager = get_node(npc_state_manager_node)
@onready var game_event_manager: GameEventTracker = get_node(game_event_manager_node)

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
	var dialogue_data : DialogueData = _select_dialogue(entity_tag)
	_dialogue_interface.show_dialogue(dialogue_data)


#---------------------------------------------------------------------------------------------------
## Picks a piece of dialogue matching conditions.
func _select_dialogue(entity_tag: String) -> DialogueData:
	_current_npc_tag = entity_tag
	var dialogue_tag = npc_state_manager.get_next_dialogue_tag(entity_tag)
	var game_tags := []
	
	# Get the tags for the npc and world.
	game_tags.append_array(npc_state_manager.get_tags(entity_tag))
	game_tags.append_array(game_event_manager.get_active_tags())
	
	# Selects the first dialogue with valid tags.
	var pool : Array = _dialogue_data.get(dialogue_tag, [])
	for entry in pool:
		var conditions : Array = entry.conditions
		
		if _matches(conditions, game_tags):
			_current_dialogue = DialogueData.new(entry)
			return _current_dialogue
			
	return null  ## fallback


#---------------------------------------------------------------------------------------------------
func option_selected(option_no : int) -> DialogueData:
	if option_no < _current_dialogue.responses.size():
		var response : Dictionary = _current_dialogue.responses[option_no]
		var next_dialogue_tag : String = response.get("next_dialogue_tag", "")
				
		# Retrieve and set the next dialogue for this NPC based on the chosen dialogue.
		npc_state_manager.set_next_dialogue_tag(_current_npc_tag, next_dialogue_tag)
		
		# Replace this by calling the interface to display this.
		var next_dialogue = _select_dialogue(_current_npc_tag)
		return next_dialogue
	
	return null

# Note: Should add a "continue" option to a dialogue object to automatically
# 	populate a "continue..." dialogue.


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
