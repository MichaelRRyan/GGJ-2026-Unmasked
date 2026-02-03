extends Control
class_name DialogueInterface

var ResponseOptionScene = preload("res://Features/DialogueSystem/dialogue_option.tscn")


## Sets the interface to hidden on game start.
#-------------------------------------------------------------------------------
func _ready():
	DialogueController._dialogue_interface = self
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
		if dialogue_data.has_valid_response():
			_add_response_options(dialogue_data.responses)
		
		else: # Else display a "Continue..." button,
			_add_continue_button()
	
	else:
		_add_continue_button()


#-------------------------------------------------------------------------------
func _add_response_options(responses : Array) -> void:
	for i in responses.size():
		var response : DialogueData = responses[i]
		if response.enabled:
			
			# Setup and populate the response option scene.
			var optionScene : Button = ResponseOptionScene.instantiate()
			optionScene.text = response.text
			optionScene.connect("pressed", _option_selected.bind(i))
			$DialogueOptions.add_child(optionScene)


#-------------------------------------------------------------------------------
func _add_continue_button() -> void:
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
	
	var dialogue_data : DialogueData = DialogueController.option_selected(option_no)
	if dialogue_data != null:
		call_deferred("_display_dialogue", dialogue_data)
	else:
		visible = false


#-------------------------------------------------------------------------------
func _on_continue_pressed():
	# Delete all the response options.
	for child in $DialogueOptions.get_children():
		child.queue_free()
	
	visible = false


#-------------------------------------------------------------------------------
