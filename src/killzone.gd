extends Area2D

@onready var gameState: Node = %gameState
@onready var timer: Timer = $Timer

# Kill viable objects on collision
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		timer.start()
		print("Game Over: Player hit the killzone!")

func _on_timer_timeout():
		gameState.resetLevel()
	
