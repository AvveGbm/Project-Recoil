extends Area2D

var was_picked_up = false

func _on_body_entered(body: Node2D) -> void:
	for child in get_children():
		if child.has_method("process_pick_up"):
			child.process_pick_up(body)
			was_picked_up = true

	if was_picked_up:
		queue_free()
