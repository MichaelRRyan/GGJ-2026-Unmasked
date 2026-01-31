extends Area2D

signal cabinet_opened(dialogue_tag : String)

var _mouse_over_clickable = false
var _open = false

# TEMP
var dialogue_no = 0


func _ready():
	$CollisionOpened.disabled = true


func _on_mouse_entered():
	_mouse_over_clickable = true


func _on_mouse_exited():
	_mouse_over_clickable = false


func _input(event):
	if event.is_action_pressed("click") && _mouse_over_clickable:
		_clicked()


func _clicked():
	_open = !_open
	
	if _open:
		$AnimatedSprite2D.play("idle_open")
		cabinet_opened.emit("cabinet_opened" + str(dialogue_no))
		dialogue_no += 1
	else:
		$AnimatedSprite2D.play("idle_closed")
	
	$CollisionOpened.disabled = !_open
	$CollisionClosed.disabled = _open
