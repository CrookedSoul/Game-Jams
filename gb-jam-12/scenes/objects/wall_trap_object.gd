extends StaticBody2D
class_name WallTrapObject

@export var wall_trap_projectil : PackedScene
@export var is_fast : bool
@export var is_ultra_slow : bool

@onready var animation_player = $AnimationPlayer
@onready var launch_position = $LaunchPosition


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var randomFloat = randf_range(0.0, 1.0)
	await get_tree().create_timer(randomFloat).timeout
	if is_fast:
		animation_player.play("fast_spawning")
	elif is_ultra_slow:
		animation_player.play("ultra_slow_spawning")
	else:
		animation_player.play("slow_spawning")


func shoot_projectile():
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer");
	var projectile_instance = wall_trap_projectil.instantiate()
	foreground_layer.add_child(projectile_instance)
	projectile_instance.is_enemy_projectile = true
	projectile_instance.global_rotation = global_rotation
	projectile_instance.global_position = launch_position.global_position
	

func slow_down():
	animation_player.play("ultra_slow_spawning")