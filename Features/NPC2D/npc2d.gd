extends Clickable
class_name NPC2D

signal npc_clicked(npc_tag : String)


@export var npc_tag : String = "guy"


func _clicked():
	npc_clicked.emit(npc_tag)
