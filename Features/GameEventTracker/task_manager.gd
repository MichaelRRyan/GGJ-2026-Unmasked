extends Node
class_name TaskManager

## Stores quest flags or IDs.
var _tasks: Array = []

## Activate a quest/task.
func activate_task(id: String) -> void:
	"""Start a quest or task by adding it to the set."""
	_tasks.push_back(id)

## Complete a quest.
func complete_task(id: String) -> void:
	"""Remove a quest or task upon completion."""
	_tasks.erase(id)

## Check if a quest is active.
func is_task_active(id: String) -> bool:
	"""Query if a quest is currently active."""
	return _tasks.has(id)
