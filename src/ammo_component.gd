extends Node
class_name AmmoComponent

@export var recover_by: int

## Calls refill fuction on player's weapon
func process_pick_up(body: Node2D) -> void:
	print("Ammo get!")
	if body is Player:
		var player : Player = body
		player.weapon.refill(recover_by)
