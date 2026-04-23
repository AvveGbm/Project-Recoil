extends CanvasLayer


@export var ammo_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await GameState.game_loaded
	update_ammo_label(GameState.player.weapon.current_ammo, GameState.player.weapon.max_ammo)
	GameState.player.weapon.ammo_changed.connect(_on_ammo_changed)
	
func _on_ammo_changed(current, max: int):
	update_ammo_label(current, max)
	
func update_ammo_label(amount, max: int):
	ammo_label.text = "AMMO: " + str(amount) + "/" + str(max)
	
