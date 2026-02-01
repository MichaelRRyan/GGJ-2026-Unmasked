extends Clickable

signal npc_clicked(npc_tag : String)

@export var baker_tag : String = "baker"

func _clicked():
	print("BAKER CLICKED")
	npc_clicked.emit(baker_tag)
