extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.current_level = get_node('.')
	print(get_path())
	var spawn_node: Node2D
	spawn_node = get_child(-1)
	GameState.current_level_spawn_position = spawn_node.global_position
	
