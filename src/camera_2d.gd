extends Camera2D

@export var follow_target: NodePath
@export var follow_speed: float = 8.0
@export var follow_offset: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var follow_target := get_node_or_null(follow_target) as Node2D
	if follow_target == null:
		return

	var target: Vector2 = follow_target.global_position + follow_offset
	global_position = global_position.lerp(target, 1.0 - exp(-follow_speed * delta))
