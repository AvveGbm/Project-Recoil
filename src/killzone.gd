extends Area2D

@onready var timer: Timer = $Timer

# Kill viable objects on collision
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		timer.start()
		print("Game Over: Player hit the killzone!")

func _on_timer_timeout():
		GameState.reset_level()
	
