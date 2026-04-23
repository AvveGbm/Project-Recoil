extends Node
class_name ScoreComponent

@export var score_change: int

func process_pick_up(_body: Node2D) -> void:
	GameState.increase_score(score_change)
	print("Picked up Coin worth " + str(score_change))
	## Play sound
