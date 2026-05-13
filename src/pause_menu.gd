extends Control

func _ready() -> void:
	visible = false
	
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
func open() -> void:
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
