extends Control

@export var score_label: Label
@export var ammo_label: Label

@export var timer_label: Label
var time_elapsed: float = 0.0

func _ready() -> void:
	await GameState.game_loaded
	_initial_update()
	GameState.player.weapon.ammo_changed.connect(_on_ammo_changed)
	GameState.level_score_changed.connect(_on_score_changed)

# Timer using _process for millisecond precision.
func _process(delta: float) -> void:
	if !GameState.player.has_moved:
		reset_time_elapsed()
	else:
		time_elapsed += delta
		
	var minutes: int = floori(time_elapsed / 60.0)
	var seconds: int = floori(time_elapsed) % 60
	var hundredths: int = floori(fmod(time_elapsed, 1) * 100)
	
	var timer_text_formatted = "%02d:%02d.%02d" % [minutes, seconds, hundredths]
	
	timer_label.text = timer_text_formatted

func _on_ammo_changed(current, total: int):
	update_ammo_label(current, total)

func _on_score_changed(score: int):
	update_score_label(score)
	
func _initial_update():
	update_ammo_label(GameState.player.weapon.current_ammo, GameState.player.weapon.max_ammo)
	update_score_label(GameState.player_score)
	
func update_score_label(score: int):
	score_label.text = "SCORE: " + str(score)

func update_ammo_label(amount, total: int):
	ammo_label.text = "AMMO: " + str(amount) + "/" + str(total)
	
func reset_time_elapsed() -> void:
	time_elapsed = 0.0
	
