extends Node2D
class_name WallTrapProjectile

var is_enemy_projectile: bool = false;
var previous_projectile_data: bool; 
var speed: int = 100
var durability: int = 0

@onready var hitbox_component = $HitboxComponent

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * speed * delta
