extends Control

@onready var level_select_debug = $VBoxContainer/LevelSelectDebug

func _ready() -> void:
	visible = true

func _on_play_button_pressed() -> void:
	visible = false
	GameState.start_game(level_select_debug.value)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
