extends Camera2D

## Target node for the camera to follow.
@export var follow_target: NodePath
## How quickly the camera catches up to the target. 
## Higher values make the camera "snappier," while lower values make it "lazier."
@export var follow_smoothing: float = 5.0
## Adjusts the camera's view away from the target's center. 
## Use this to look higher up (negative Y) or further ahead (X).
@export var follow_offset: Vector2 = Vector2(40,0)
## How far the camera is allowed to fall behind before it's dragged along.
## 1.0 = The leash is as long as the screen (player can reach the very edge).
## 0.5 = The leash is short (player is kept in the middle 50% of the screen).
@export_range(0.0, 1.0) var visibility_leash: float = 0.5
func _physics_process(delta: float) -> void:
	var follow_target := get_node_or_null(follow_target) as Node2D
	if follow_target == null:
		return

	var target_pos: Vector2 = follow_target.global_position + follow_offset
	global_position = global_position.lerp(target_pos, 1.0 - exp(-follow_smoothing * delta))
	var screen_size = get_viewport_rect().size / zoom
	var limit = (screen_size * visibility_leash) / 2.0
	var diff = global_position - target_pos
	global_position.x = target_pos.x + clamp(diff.x, -limit.x, limit.x)
	global_position.y = target_pos.y + clamp(diff.y, -limit.y, limit.y)
