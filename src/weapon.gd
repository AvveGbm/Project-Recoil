extends Node2D
class_name Weapon

@export_group("Settings")
## The bullet the weapon shoots.
@export var bullet_scene: PackedScene
## Amount of recoil force applied to the shooter per shot.
@export var recoil_strength: float = 300.0
## Minimum time (in seconds) between shots.
@export var shot_cooldown: float = 0.2
## Maximum ammo capacity of the weapon.
@export var max_ammo: int = 10

@onready var muzzle = $Muzzle

var is_on_cooldown: bool
var current_ammo: int

func _ready() -> void:
	is_on_cooldown = false
	current_ammo = max_ammo
	
## Returns true if the weapon is able to fire.
func can_shoot() -> bool:
	return not is_on_cooldown and current_ammo > 0 and bullet_scene != null

## Fires a bullet if possible.
## Spawns a bullet instance.
## Consumes ammo and starts cooldown.
##
## Returns recoil_strength if a shot was fired or 0.0 if firing was not possible.
func shoot() -> float:
	if not can_shoot():
		return 0.0
	
	var bullet := bullet_scene.instantiate() as Bullet
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_position = muzzle.global_position
	bullet.direction = Vector2.RIGHT.rotated(global_rotation)
	bullet.rotation = global_rotation
	
	current_ammo -= 1
	start_cooldown()

	return recoil_strength

## Starts the firing cooldown timer.
func start_cooldown():
	is_on_cooldown = true
	await get_tree().create_timer(shot_cooldown).timeout
	is_on_cooldown = false

## Adds amount to the weapons current_ammo. Will not go above max_ammo.
func refill(amount: int) -> void:
	if amount <= 0:
		return
	current_ammo = min(current_ammo+amount, max_ammo)

## Fully refills ammo to max_ammo
func refill_full() -> void:
	current_ammo = max_ammo
