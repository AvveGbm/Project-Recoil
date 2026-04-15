extends Node2D
class_name Weapon

@export_group("Settings")
@export var projectile_scene: PackedScene
@export var recoil_strength: float = 300.0
@export var fire_rate: float = 0.2

@onready var muzzle = $Muzzle

var can_fire: bool = true

func shoot() -> float:
	if not can_fire:
		return 0.0
	
	if not projectile_scene:
		print("Warning: No projectile_scene assigned to the weapon")
	
	var bullet = projectile_scene.instantiate()
	
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_position = muzzle.global_position
	
	bullet.direction = Vector2.RIGHT.rotated(global_rotation)
	bullet.rotation = global_rotation

	start_cooldown()

	return recoil_strength

func start_cooldown():
	can_fire = false
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true
