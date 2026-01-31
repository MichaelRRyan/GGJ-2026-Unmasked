extends Clickable
class_name NPC2D


@export var npc_tag : String = "guy"


func _clicked():
	DialogueController.show_dialogue(npc_tag)
