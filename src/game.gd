extends Node2D

@export var levels: Array[PackedScene]

@onready var level_container: Node2D = $levelContainer
@onready var player: Player = $Player
@onready var loading_screen = $UI/LoadingScreen
@onready var pause_menu = $UI/PauseMenu

func _ready() -> void:
	player.visible = false
	player.process_mode = Node.PROCESS_MODE_DISABLED
	GameState.register_game(self, level_container, player, loading_screen, levels)

func _unhandled_input(event: InputEvent) -> void:
	if not GameState.game_started:
		return
	
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			pause_menu.close()
		else:
			pause_menu.open()
