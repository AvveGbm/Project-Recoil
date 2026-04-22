extends Area2D

@onready var timer: Timer = $Timer

# Kill viable objects on collision
func _on_body_entered(body: Node2D) -> void:
	if body == GameState.player:
		print("Game Over: Player hit the killzone!")
		GameState.reset_level(0.3)
