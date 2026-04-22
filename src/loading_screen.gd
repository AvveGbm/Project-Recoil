extends CanvasLayer

@onready var color_rect: ColorRect = $background
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	layer = 100
	color_rect.color.a = 0.0

func fade_in() -> void:
	animation_player.play("fade_in")
	await animation_player.animation_finished


func fade_out() -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished
