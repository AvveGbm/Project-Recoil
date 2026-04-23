extends Node

## Central game-flow singleton.
## Responsibilities:
## - keep refrences to the persistent game nodes
## - remember level order and current level
## - handle level reset / next level transitions
## - find the active level's spawn point
## - detect softlock situations and reset the level when needed

var game_root: Node
var level_container: Node2D
var player: Player
var loading_screen: CanvasLayer

var player_health: int # Unused
var player_score: int

## Ordered list of levels assigned by game.gd.
## GameState transitions through these by index.
var level_scenes: Array[PackedScene] = []

## Runtime state for the currently loaded level
var current_level_index: int = -1
var current_level: Node2D
var current_level_spawn_position: Vector2 = Vector2.ZERO

## Prevents overlapping transitions and duplicate resets.
var transition_in_progress: bool = false

## One-shot timer used for delayed softlock reset.
## If the player is stuck without ammo and cannot move,
## the timer starts and resets the level after a short delay.
var softlock_timer: Timer

## Signal used 
signal game_loaded

func _ready() -> void:
	# Create the timer in code so GameState does not depend on a scene child.
	softlock_timer = Timer.new()
	softlock_timer.one_shot = true
	softlock_timer.wait_time = 2.0
	softlock_timer.timeout.connect(_on_softlock_timer_timeout)
	add_child(softlock_timer)

func _physics_process(_delta: float) -> void:
	# Do not evaluate softlock logic during transitions,
	# or before the player reference has been registered.
	if transition_in_progress or player == null:
		return
	
	# Start the timer once the palyer is confirmed softlocked.
	# Stop it again immediatly if the softlock condition is broken.
	if _should_softlock_reset():
		if softlock_timer.is_stopped():
			softlock_timer.start()
	else:
		if not softlock_timer.is_stopped():
			softlock_timer.stop()

## Called once by game.gd to register the persistent scene references.
func register_game(
	p_game_root: Node,
	p_level_container: Node2D,
	p_player: Player,
	p_loading_screen: CanvasLayer,
	p_level_scenes: Array[PackedScene],
) -> void:
	game_root = p_game_root
	level_container = p_level_container
	player = p_player
	loading_screen = p_loading_screen
	level_scenes = p_level_scenes

## Starts the game by loading the requested level index.
func start_game(start_level_index: int = 0) -> void:
	await _transition_to_level(start_level_index, false)
	game_loaded.emit()

## Reloads the current level with a fade transition, optionally after a short delay.
func reset_level(delay: float = 0.0) -> void:
	if transition_in_progress:
		return
		
	if current_level_index == -1:
		push_error("GameState.reset_level(): cannot reset, no current level.")
		return
	
	if delay > 0.0:
		await get_tree().create_timer(delay).timeout
	
	await _transition_to_level(current_level_index, true)

## Loads the next level in the onfigured order
## If there is no next level, nothing happens.
func next_level() -> void:
	var next_index := current_level_index + 1
	if next_index >= level_scenes.size():
		print("GameState.next_level(): No more levels.")
		return
	await _transition_to_level(next_index, true)

## Increments total player score by amount
func increase_score(amount: int) -> void:
	player_score += amount
	print("Total score: " + str(player_score))

## Handles the full level transition to the level with level_index.
## if use_fade it will add a transition with loading_screen.fade_in / loading_screen.fade_out
func _transition_to_level(level_index: int, use_fade: bool) -> void:
	if transition_in_progress:
		return
	
	if level_index < 0 or level_index >= level_scenes.size():
		push_error("GameState: invalid level index: %s" % level_index)
		return
	
	transition_in_progress = true
	
	if use_fade and loading_screen != null:
		await loading_screen.fade_in()
		
	for child in level_container.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	await get_tree().physics_frame
	
	var level_instance := level_scenes[level_index].instantiate() as Node2D
	
	current_level_spawn_position = _find_spawn_position(level_instance)
	player.reset_for_level(current_level_spawn_position)
	
	await get_tree().process_frame
	await get_tree().physics_frame
	
	level_container.add_child(level_instance)
	
	current_level_index = level_index
	current_level = level_instance
	
	await get_tree().process_frame
		
	if use_fade and loading_screen != null:
		await loading_screen.fade_out()
	
	transition_in_progress = false

## Finds the spawn marker inside a level scene
## Every level is expected to contain a Marker2D named "SpawnLocation".
func _find_spawn_position(level: Node) -> Vector2:
	var spawn := level.get_node_or_null("SpawnLocation") as Marker2D
	if spawn == null:
		push_error("GameState: level '%s' has no Marker2D named SpawnLocation." % level.name)
		return Vector2.ZERO
	return spawn.global_position

## Returns true if the player is effectively softlocked and should reset.
## Used to reset when player runs out of ammo and is stationary.
func _should_softlock_reset() -> bool:
	if player == null:
		return false
	
	if not player.is_on_floor():
		return false
	
	if player.velocity != Vector2.ZERO:
		return false
	
	if player.weapon == null:
		return false
	
	if player.weapon.current_ammo > 0:
		return false
		
	return true

## Called when the softlock timer completes.
## Re-checks the condition in case the player became unstuck before timeout.
func _on_softlock_timer_timeout() -> void:
	if _should_softlock_reset():
		reset_level()
