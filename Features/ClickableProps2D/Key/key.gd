extends Area2D

var mouse_over := false


func _on_mouse_entered():
	mouse_over = true


func _on_mouse_exited():
	mouse_over = false


func _input(event):
	if event.is_action_pressed("click") and mouse_over:
		queue_free()
