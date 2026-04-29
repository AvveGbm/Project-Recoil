@tool
extends AnimatableBody2D

const TILE_SIZE := 16
const DEFAULT_TEXTURE := preload("res://assets/tilesets/single_brick_block.png")


@export_group("Platform")

## Platform size in whole tiles.
@export var platform_size_tiles: Vector2i = Vector2i(3, 1):
	set(value):
		platform_size_tiles = Vector2i(max(value.x, 1), max(value.y, 1))
		_update_platform()


## Optional texture override.
## Leave empty to use res://assets/tilesets/single_brick_block.png.
@export var texture_override: Texture2D:
	set(value):
		texture_override = value
		queue_redraw()


@export_group("Movement")

## End position relative to this node, measured in whole tiles.
@export var end_offset_tiles: Vector2i = Vector2i(6, 0):
	set(value):
		end_offset_tiles = value
		queue_redraw()


## Movement speed in tiles per second.
@export_range(0.25, 32.0, 0.25, "or_greater", "suffix:tiles/sec")
var movement_speed_tiles_per_second: float = 1.0:
	set(value):
		movement_speed_tiles_per_second = value

## Wait time at each end before moving back.
@export_range(0.0, 10.0, 0.1, "or_greater", "suffix:sec")
var wait_time_at_ends: float = 0.0


@export_group("Editor Preview")

## Show movement line and end-position outline in the editor.
@export var show_movement_preview: bool = true:
	set(value):
		show_movement_preview = value
		queue_redraw()


var _start_position: Vector2
var _end_position: Vector2

var _move_progress := 0.0
var _move_duration := 1.0
var _is_waiting := false


func _ready() -> void:
	_update_platform()

	if Engine.is_editor_hint():
		return

	_start_position = global_position
	_end_position = _start_position + _get_end_offset_in_pixels()


	var distance_pixels := _start_position.distance_to(_end_position)
	var speed_pixels_per_second := movement_speed_tiles_per_second * TILE_SIZE

	_move_duration = max(distance_pixels / speed_pixels_per_second, 0.001)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if _is_waiting:
		return

	_move_progress += delta / _move_duration

	var t := clampf(_move_progress, 0.0, 1.0)

	global_position = _start_position.lerp(_end_position, t)

	if _move_progress >= 1.0:
		global_position = _end_position
		_reached_target()


func _reached_target() -> void:
	_move_progress = 0.0
	
	var temp := _start_position
	_start_position = _end_position
	_end_position = temp

	if wait_time_at_ends > 0.0:
		_is_waiting = true
		await get_tree().create_timer(wait_time_at_ends).timeout
		_is_waiting = false


func _update_platform() -> void:
	_update_collision()
	queue_redraw()

func _update_collision() -> void:
	var collision_shape_node := get_node_or_null("CollisionShape2D") as CollisionShape2D
	if collision_shape_node == null:
		return

	if collision_shape_node.shape == null or not collision_shape_node.shape is RectangleShape2D:
		collision_shape_node.shape = RectangleShape2D.new()

	if not collision_shape_node.shape.resource_local_to_scene:
		collision_shape_node.shape = collision_shape_node.shape.duplicate()
		collision_shape_node.shape.resource_local_to_scene = true

	var rectangle_shape := collision_shape_node.shape as RectangleShape2D
	rectangle_shape.size = _get_platform_size_in_pixels()


func _get_texture() -> Texture2D:
	if texture_override != null:
		return texture_override

	return DEFAULT_TEXTURE


func _get_platform_size_in_pixels() -> Vector2:
	return Vector2(platform_size_tiles * TILE_SIZE)


func _get_end_offset_in_pixels() -> Vector2:
	return Vector2(end_offset_tiles * TILE_SIZE)


func _draw() -> void:
	_draw_platform(Vector2.ZERO)

	if Engine.is_editor_hint() and show_movement_preview:
		_draw_editor_preview()


func _draw_platform(offset: Vector2) -> void:
	var texture := _get_texture()
	if texture == null:
		return

	var platform_size_pixels := _get_platform_size_in_pixels()
	var top_left_position := offset - platform_size_pixels / 2.0

	for tile_y in range(platform_size_tiles.y):
		for tile_x in range(platform_size_tiles.x):
			var tile_position := top_left_position + Vector2(tile_x, tile_y) * TILE_SIZE
			draw_texture(texture, tile_position)


func _draw_editor_preview() -> void:
	var end_offset_pixels := _get_end_offset_in_pixels()
	var platform_size_pixels := _get_platform_size_in_pixels()

	draw_line(Vector2.ZERO, end_offset_pixels, Color.YELLOW, 2.0)

	draw_circle(Vector2.ZERO, 4.0, Color.GREEN)
	draw_circle(end_offset_pixels, 4.0, Color.RED)

	var end_platform_rect := Rect2(
		end_offset_pixels - platform_size_pixels / 2.0,
		platform_size_pixels
	)

	draw_rect(end_platform_rect, Color.CYAN, false, 1.0)
