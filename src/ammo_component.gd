extends Node
class_name AmmoComponent

@export var recover_by: int

## Calls refill fuction on player's weapon
func _on_ammo_body_entered(body: Node2D) -> void:
	if body is Player:
		var player : Player = body
		player.weapon.refill(recover_by)
		get_parent().queue_free()
