extends Area2D
class_name Bullet
@export_group("Bullet Settings")
## The speed of the bullet
@export var speed: float = 200.0
var direction: Vector2 = Vector2.RIGHT

func _process(delta: float) -> void:
		position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	queue_free() # Removes bullet when it hits something
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
		queue_free() # Removes bullet when exiting the screen
