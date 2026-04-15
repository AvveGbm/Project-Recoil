extends CharacterBody2D

@export_group("Movement Settings")
@export var friction: float = 0.15

@onready var weapon_slot = $WeaponSlot
@onready var weapon: Weapon = $WeaponSlot/Weapon

func _physics_process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	weapon_slot.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		fire_weapon()
	
	velocity = velocity.lerp(Vector2.ZERO, friction)
	
	move_and_slide()
	
func fire_weapon() -> void:
	if weapon:
		var recoil_force = weapon.shoot()
		if recoil_force > 0:
			var look_direction = (get_global_mouse_position() - global_position).normalized()
			velocity = -look_direction * recoil_force
