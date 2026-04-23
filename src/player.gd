extends CharacterBody2D
class_name Player

@export_group("Movement Settings")
@export var ground_friction: float = 14.0
@export var air_drag: float = 1
@export var gravity: float = 500.0
@export var max_speed: float = 300.0

@export_group("Fire Buffer")
@export var fire_buffer_time: float = 0.12

@onready var weapon_slot = $WeaponSlot
@onready var weapon: Weapon = $WeaponSlot/Weapon

var fire_buffer_timer: float = 0.0

## Resets player fields to their defaults
func reset_for_level(spawn_position: Vector2) -> void:
	weapon.refill_full()
	global_position = spawn_position
	velocity = Vector2.ZERO
	fire_buffer_timer = 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, 1500)
	
	var mouse_pos = get_global_mouse_position()
	weapon_slot.look_at(mouse_pos)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		fire_buffer_timer = fire_buffer_time

	if fire_buffer_timer > 0.0:
		fire_buffer_timer -= delta
		if try_fire_weapon():
			fire_buffer_timer = 0.0
		
	var current_drag = ground_friction if is_on_floor() else air_drag
	velocity.x = move_toward(velocity.x, 0, current_drag * 100 * delta)
	
	move_and_slide()
	
func try_fire_weapon() -> bool:
	if not weapon:
		return false

	var recoil_force = weapon.shoot()
	if recoil_force <= 0:
		return false

	var look_direction = (get_global_mouse_position() - global_position).normalized()
	velocity += -look_direction * recoil_force
	velocity = velocity.limit_length(max_speed)
	return true
