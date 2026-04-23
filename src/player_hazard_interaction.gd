extends Area2D



func _on_body_entered(_body: Node2D) -> void:
	GameState.reset_level(0.3)
