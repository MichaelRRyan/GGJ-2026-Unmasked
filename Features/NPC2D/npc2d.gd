extends Clickable
class_name NPC2D


@export var npc_tag : String = "guy"

var _mask_removed = false


func _ready() -> void:
	_pick_animation()
	
	GameEventTracker.event_tag_added.connect(_on_game_event_tag_added)


func _clicked():
	DialogueController.show_dialogue(npc_tag)


func _on_game_event_tag_added(game_tag : String) -> void:
	if game_tag == npc_tag + "_unmasked":
		_remove_mask()


func _remove_mask():
	match npc_tag:
		"baker":
			$AnimatedSprite2D.play("baker_remove_mask")
		"barman":
			$AnimatedSprite2D.play("barman_remove_mask")
		"nun":
			$AnimatedSprite2D.play("nun_remove_mask")
		"witch":
			$AnimatedSprite2D.play("witch_remove_mask")


func _pick_animation():
	match npc_tag:
		"baker":
			if _mask_removed:
				$AnimatedSprite2D.play("baker_no_mask_idle")
			else:
				$AnimatedSprite2D.play("baker_idle")
		"barman":
			if _mask_removed:
				$AnimatedSprite2D.play("barman_no_mask_idle")
			else:
				$AnimatedSprite2D.play("barman_idle")
		"nun":
			if _mask_removed:
				$AnimatedSprite2D.play("nun_no_mask_idle")
			else:
				$AnimatedSprite2D.play("nun_idle")
		"witch":
			if _mask_removed:
				$AnimatedSprite2D.play("witch_no_mask_idle")
			else:
				$AnimatedSprite2D.play("witch_idle")
		"farmer":
			$AnimatedSprite2D.play("farmer_idle")


func _on_animation_finished() -> void:
	if $AnimatedSprite2D.animation == npc_tag + "_remove_mask":
		_pick_animation()
