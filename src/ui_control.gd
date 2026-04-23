extends CanvasLayer


@export var score_label: Label
@export var ammo_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await GameState.game_loaded
	_initial_update()
	GameState.player.weapon.ammo_changed.connect(_on_ammo_changed)
	GameState.score_changed.connect(_on_score_changed)
	
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
	
