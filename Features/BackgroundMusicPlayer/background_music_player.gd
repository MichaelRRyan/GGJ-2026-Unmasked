extends Node


var bgm_player : AudioStreamPlayer


#---------------------------------------------------------------------------------------------------
func _ready():
	bgm_player = AudioStreamPlayer.new()
	add_child(bgm_player)
	get_tree().scene_changed.connect(_select_audio)
	_select_audio()


#---------------------------------------------------------------------------------------------------
func _select_audio():
	var current_path = get_tree().current_scene.scene_file_path
	if current_path == "res://Levels/level_bar.tscn":
		_load_and_play_audio("res://Assets/Audio/unmasked_bar_theme.wav")
	elif current_path == "res://Levels/level_witch_tower.tscn":
		_load_and_play_audio("res://Assets/Audio/unmasked_witch_theme.wav")
	elif current_path == "res://Levels/level_bakery.tscn": # Fixed logic here
		_load_and_play_audio("res://Assets/Audio/unmasked_end_screen.wav")
	else: 
		_load_and_play_audio("res://Assets/Audio/unmasked_theme.mp3")
	

#---------------------------------------------------------------------------------------------------
func _load_and_play_audio(path : String):
	var new_song = load(path)
	if bgm_player.stream != new_song:
		bgm_player.stream = new_song
		bgm_player.play(0.0)
