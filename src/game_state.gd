extends Node

var player_health: int # Unused
var current_level # Unused
var player_score: int

@onready var level_container: Node2D = $"../levelContainer"

func _ready() -> void:
		player_score = 0

## Reloads the active scene, used as a level reset
func reset_level():
	get_tree().reload_current_scene()

## Increments total player score by amount
func increase_score(amount: int) -> void:
	player_score += amount
	print("Total score: " + str(player_score))
