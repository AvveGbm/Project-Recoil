extends Node2D
class_name ScoreComponent

@export var score_change: int

func _on_area_2d_body_entered(_body: Node2D) -> void:
	GameState.increase_score(score_change)
	print("Picked up Coin worth " + str(score_change))
	## Play sound
	get_parent().queue_free()
