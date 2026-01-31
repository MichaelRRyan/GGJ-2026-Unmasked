extends Control
class_name DialogueInterface

@export var dialogue_picker_node: NodePath
@export var use_fade_timer = false

@onready var picker: DialoguePicker = get_node(dialogue_picker_node)


## Sets the interface to hidden on game start.
#-------------------------------------------------------------------------------
func _ready():
	self.hide()


## Display dialogue when NPC emits a signal.
#-------------------------------------------------------------------------------
func show_dialogue(npc_tag: String) -> void:
	self.show()
	
	var text := picker.select_dialogue(npc_tag)
	_display_dialogue(text)


#-------------------------------------------------------------------------------
func _display_dialogue(text: String) -> void:
	$ColorRect/Label.text = text
	
	if use_fade_timer:
		$FadeTimer.start()


#-------------------------------------------------------------------------------
func _on_option_1_pressed():
	_option_selected(0)
	
func _on_option_2_pressed():
	_option_selected(1)
	
func _on_option_3_pressed():
	_option_selected(2)


#-------------------------------------------------------------------------------
func _option_selected(option_no : int) -> void:
	var dialogue_text = picker.option_selected(option_no)
	if dialogue_text != "":
		_display_dialogue(dialogue_text)
	else:
		visible = false


#-------------------------------------------------------------------------------
func _on_fade_timer_timeout():
	visible = false


func _on_key_mouse_entered() -> void:
	pass # Replace with function body.


func _on_key_mouse_exited() -> void:
	pass # Replace with function body.
