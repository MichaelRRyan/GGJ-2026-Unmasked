extends Control
class_name DialogueInterface

@export var dialogue_picker_node: NodePath

@onready var picker: DialoguePicker = get_node(dialogue_picker_node)

var ResponseOptionScene = preload("res://Features/DialogueSystem/dialogue_option.tscn")


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
		
		# Display dialogue options as buttons.
		if not dialogue_data.responses.is_empty():
			for i in dialogue_data.responses.size():
				var optionScene : Button = ResponseOptionScene.instantiate()
				optionScene.text = dialogue_data.responses[i].text
				optionScene.connect("pressed", _option_selected.bind(i))
				$DialogueOptions.add_child(optionScene)
				
		# Else display a "Continue..." button,
		else:
			var optionScene : Button = ResponseOptionScene.instantiate()
			optionScene.text = "Continue..."
			optionScene.connect("pressed", _on_continue_pressed)
			$DialogueOptions.add_child(optionScene)


#-------------------------------------------------------------------------------
# Informs the dialogue controller an option has been clicked.
# 	If the controller returns text, displays a new message.
# 	Otherwise, hides the UI.
func _option_selected(option_no : int) -> void:
	# Delete all the response options.
	for child in $DialogueOptions.get_children():
		child.queue_free()
	
	var dialogue_data : DialogueData = picker.option_selected(option_no)
	if dialogue_data != null:
		_display_dialogue(dialogue_data)
	else:
		visible = false


#-------------------------------------------------------------------------------
func _on_continue_pressed():
	# Delete all the response options.
	for child in $DialogueOptions.get_children():
		child.queue_free()
	
	visible = false


#-------------------------------------------------------------------------------
