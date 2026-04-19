extends Node

var player_health: int # Unused
var current_level := "res://scenes/levels/level_test.tscn"
var player_score: int

@onready var level_container: Node2D
@onready var player: Player


func _ready() -> void:
	player_score = 0

func _process(_delta: float) -> void:
	player_can_move()

## Reloads the active scene, used as a level reset
func reset_level():
	LoadingScreen.switch_scene(current_level)
	await LoadingScreen.scene_loaded
	get_tree().call_deferred("change_scene_to_packed", LoadingScreen.scene_to_load)
	

## Increments total player score by amount
func increase_score(amount: int) -> void:
	player_score += amount
	print("Total score: " + str(player_score))

## Resets level if player isn't moving and is further
## unable to move, e.g. by being out of ammo.
func player_can_move():
	if player == null:
		print("No player!")
		return
	if player.is_on_floor() and player.weapon.current_ammo == 0:
		var time_until_reset := 2.0 # To avoid resetting at the apex of a leap
		await get_tree().create_timer(time_until_reset).timeout
		if  player.velocity == Vector2.ZERO:
			await get_tree().process_frame
			reset_level()
