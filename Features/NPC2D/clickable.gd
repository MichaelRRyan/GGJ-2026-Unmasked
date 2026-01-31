extends Area2D
class_name Clickable


var _mouse_over_clickable = false


func _mouse_enter():
	_mouse_over_clickable = true


func _mouse_exit():
	_mouse_over_clickable = false


func _input(event):
	if event.is_action_pressed("click") && _mouse_over_clickable:
		_clicked()


## Virtual - To be overridden
func _clicked():
	pass
