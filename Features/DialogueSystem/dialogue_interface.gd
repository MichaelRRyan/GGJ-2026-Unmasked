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
func show_dialogue(dialogue_data: DialogueData) -> void:
	self.show()
	_display_dialogue(dialogue_data)


#-------------------------------------------------------------------------------
func _display_dialogue(dialogue_data: DialogueData) -> void:
	# If data is valid (not null)
	if dialogue_data:
		$ColorRect/Label.text = dialogue_data.text
		
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
# Informs the dialogue controller an option has been clicked.
# 	If the controller returns text, displays a new message.
# 	Otherwise, hides the UI.
func _option_selected(option_no : int) -> void:
	var dialogue_data : DialogueData = picker.option_selected(option_no)
	if dialogue_data != null:
		_display_dialogue(dialogue_data)
	else:
		visible = false


#-------------------------------------------------------------------------------
func _on_fade_timer_timeout():
	visible = false
