extends Clickable
class_name Door2D

@export_file_path(".tscn") var scene = ""

func _clicked():
	get_tree().change_scene_to_file(scene)
