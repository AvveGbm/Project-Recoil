extends Control

func _ready() -> void:
	visible = true

func _on_play_button_pressed() -> void:
	visible = false
	GameState.start_game(0)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
