extends Node

@onready var loading_scene = preload("res://scenes/loading_screen.tscn")

var new_scene_path: String
var is_loading := false
var scene_to_load

signal scene_loaded

func _process(_delta: float) -> void:
	if is_loading:
		var loading_status = ResourceLoader.load_threaded_get_status(new_scene_path)
		if loading_status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			scene_to_load = ResourceLoader.load_threaded_get(new_scene_path)
			is_loading = false
			scene_loaded.emit()

func switch_scene(new_scene: String):
	if new_scene:
		new_scene_path = new_scene
		var loading_scene_instance = loading_scene.instantiate()
		get_tree().get_root().call_deferred("add_child", loading_scene_instance)
	
		ResourceLoader.load_threaded_request(new_scene)
	
		is_loading = true
