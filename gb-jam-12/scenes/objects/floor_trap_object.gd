extends Node2D
class_name FloorTrapObject

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var randomFloat = randf_range(0.0, 4.0)
	await get_tree().create_timer(randomFloat).timeout
	animation_player.play("default")
