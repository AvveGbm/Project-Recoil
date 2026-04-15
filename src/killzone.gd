extends Area2D

# Kill viable objects on collision
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.queue_free()
		print("Game Over: Player hit the killzone!")
