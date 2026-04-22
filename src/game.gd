extends Node2D

@export var levels: Array[PackedScene]

@onready var level_container: Node2D = $levelContainer
@onready var player: Player = $Player
@onready var loading_screen = $LoadingScreen

func _ready() -> void:
	GameState.register_game(self, level_container, player, loading_screen, levels)
	GameState.start_game(0)
