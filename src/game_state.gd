extends Node

@onready var level_container: Node2D
@onready var player: Player

var player_health: int # Unused
var player_score: int

var current_level_path := "res://scenes/levels/level_test.tscn" # Starting level
var current_level: Node2D
var current_level_spawn_position: Vector2

var reset_underway := false
var stationary_timer_running = false

func _ready() -> void:
	player_score = 0

func _process(_delta: float) -> void:
	# Ensures only one timer runs at a time
	if !stationary_timer_running and !reset_underway:
		player_can_move()

## Reloads the active scene, used as a level reset
func reset_level():
	if !reset_underway:
		reset_underway = true
		LoadingScreen.switch_scene(current_level_path)
		await LoadingScreen.scene_loaded
		var new_scene: PackedScene
		new_scene = LoadingScreen.scene_to_load
		player.reset_player()
		level_container.get_child(0).queue_free()
		level_container.add_child(new_scene.instantiate())
		reset_underway = false
	

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
	# Ensures player can't concievably move.
	elif player.is_on_floor() and player.weapon.current_ammo == 0 and player.velocity == Vector2.ZERO:
		var time_until_reset := 2.0
		stationary_timer_running = true
		await get_tree().create_timer(time_until_reset).timeout
		
		if  player.velocity == Vector2.ZERO: # Player still stationary?
			await get_tree().process_frame
			reset_level()
			
