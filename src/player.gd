extends CharacterBody2D
class_name Player

@export_group("Movement Settings")
@export var ground_friction: float = 5.0
@export var air_drag: float = 1
@export var gravity: float = 500.0
@export var max_speed: float = 800.0

@onready var weapon_slot = $WeaponSlot
@onready var weapon: Weapon = $WeaponSlot/Weapon

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, 1500)
	
	var mouse_pos = get_global_mouse_position()
	weapon_slot.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		fire_weapon()
		
	var current_drag = ground_friction if is_on_floor() else air_drag
	velocity.x = move_toward(velocity.x, 0, current_drag * 100 * delta)
	
	move_and_slide()
	
func fire_weapon() -> void:
	if weapon:
		var recoil_force = weapon.shoot()
		if recoil_force > 0:
			var look_direction = (get_global_mouse_position() - global_position).normalized()
			velocity = -look_direction * recoil_force
