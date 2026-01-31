extends Node
class_name DialoguePicker

@export var dialogue_data_file: String = "res://Content/Dialogue/dialogue_data.json"

@export var npc_state_manager_node: NodePath
@export var game_event_manager_node: NodePath

@onready var npc_state_manager: NPCStateManager = get_node(npc_state_manager_node)
@onready var game_event_manager: GameEventTracker = get_node(game_event_manager_node)

## Stores all dialogue for all NPCs.
var _dialogue_data: Dictionary = {}  ## { "daisy": [ { "conditions": [], "text": "…" } ] }

var _current_npc_tag = null
var _current_dialogue = null


#---------------------------------------------------------------------------------------------------
func _ready() -> void:
	# Load dialogue from a file (JSON) at start-up.
	var file := FileAccess.open(dialogue_data_file, FileAccess.READ)
	if file:
		_dialogue_data = JSON.parse_string(file.get_as_text()) as Dictionary
		file.close()


#---------------------------------------------------------------------------------------------------
## Picks a piece of dialogue matching conditions.
func select_dialogue(npc_tag: String) -> String:
	_current_npc_tag = npc_tag
	var dialogue_tag = npc_state_manager.get_next_dialogue_tag(npc_tag)
	var game_tags := []
	
	# Get the tags for the npc and world.
	game_tags.append_array(npc_state_manager.get_tags(npc_tag))
	game_tags.append_array(game_event_manager.get_active_tags())
	
	# Selects the first dialogue with valid tags.
	var pool : Array = _dialogue_data.get(dialogue_tag, [])
	for entry in pool:
		var conditions : Array = entry.conditions
		
		if _matches(conditions, game_tags):
			_current_dialogue = entry
			return entry.text
			
	return "[Invalid Dialogue Tag]"  ## fallback


#---------------------------------------------------------------------------------------------------
func option_selected(option_no : int) -> String:
	var options : Array = _current_dialogue.get("options", [])
	if option_no < options.size():
		var dialogue_option : Dictionary = options.get(option_no)
		var next_dialogue_tag : String = dialogue_option.get("next_dialogue_tag", "")
				
		# Retrieve and set the next dialogue for this NPC based on the chosen dialogue.
		npc_state_manager.set_next_dialogue_tag(_current_npc_tag, next_dialogue_tag)
		
		# Replace this by calling the interface to display this.
		var next_dialogue = select_dialogue(_current_npc_tag)
		return next_dialogue
	
	return ""

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
