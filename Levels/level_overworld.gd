extends Node2D

@export var intro_tag : String = "intro"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameEventTracker.intro_played == false:
		DialogueController.show_dialogue(intro_tag)
		GameEventTracker.intro_played = true
