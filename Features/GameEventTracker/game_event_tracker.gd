extends Node
class_name GameEventTracker


#---------------------------------------------------------------------------------------------------
## Stores game-wide flags.
var _game_flags: Array = []


#---------------------------------------------------------------------------------------------------
## Activates a game event.
func activate_event(flag: String) -> void:
	# Activate a game-wide event or tag.
	_game_flags.push_back(flag)


#---------------------------------------------------------------------------------------------------
## Checks if a game event is true.
func is_event_active(flag: String) -> bool:
	# Query if a particular game-wide event is true.
	return _game_flags.has(flag)


#---------------------------------------------------------------------------------------------------
## Retrieve all active tags.
func get_active_tags() -> Array:
	# Retrieve a set of all currently true game-wide flags.
	return _game_flags


#---------------------------------------------------------------------------------------------------
