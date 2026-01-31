extends TextureButton

var is_muted := false


func _ready():
	is_muted = AudioServer.is_bus_mute(0)
	_update_icon()


func _pressed():
	is_muted = !is_muted
	AudioServer.set_bus_mute(0, is_muted)
	_update_icon()


func _update_icon():
	if is_muted:
		texture_normal = preload("res://Assets/Images/Sound/mute.png")
	else:
		texture_normal = preload("res://Assets/Images/Sound/volume.png")
