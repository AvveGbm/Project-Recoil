extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print("Goal: Body entered")
	if body == GameState.player:
		print("Goal: Player detected")
		GameState.next_level()
