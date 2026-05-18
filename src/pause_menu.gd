extends Control

@export var level_label: Label
@export var total_score_label: Label

func _ready() -> void:
	visible = false
	
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
func open() -> void:
	_update_pause_screen()
	visible = true
	get_tree().paused = true
	
func close() -> void:
	visible = false
	get_tree().paused = false
	
func _on_resume_button_pressed() -> void:
	close()

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _update_pause_screen() -> void:
	level_label.text = "LEVEL " + str(GameState.current_level_index + 1)
	total_score_label.text = "TOTAL SCORE: " + str(GameState.player_score)
