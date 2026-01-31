extends Node3D
class_name NPC

## NPC tag to identify this character in the game.
@export var npc_tag: String = ""

## Emitted when the NPC is interacted with by the player.
signal npc_interacted(npc_tag: String)

## Handle interaction (should be called by an Interaction controller or Area3D).
## Emits a signal upward with its tag.
func interact(held_item: Node3D) -> void:
	#if held_item is WateringCan:
		#var can := held_item as WateringCan
		#if can.can_water():
			#can.use()
			## Trigger dialogue, happiness, etc.
			#print("Thank you for watering me!")
			#return
	
	# Fallback to normal dialogue interaction
	# TODO: Could emit this anyways, after editing NPC state above
	emit_signal("npc_interacted", npc_tag)
