extends Node

var playerHealth
var currentLevel
@onready var game_state: Node = %gameState
@onready var level_container: Node2D = $"../levelContainer"

func resetLevel():
	get_tree().reload_current_scene()
