extends Area2D

# Kill viable objects on collision
func _on_body_entered(body: Node2D) -> void:
	body.queue_free()
