extends Area2D
class_name HurtboxComponent

@export var health_component: Node
var invulnerable = false;

# id still prefer export
var floating_text_scene = preload("res://components/floating_text.tscn")

func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return
	
	if health_component == null:
		return
	
	if invulnerable:
		return
	
	var hitbox_component = other_area as HitboxComponent
	
	deal_damage(hitbox_component.damage);
	
	#if projectile has durability reduce it
	if !hitbox_component.get_parent() is FloorTrapObject:
		hitbox_component.get_parent().queue_free();


func deal_damage(damage: int):
	if health_component == null:
		return
	
	if invulnerable:
		return
	
	health_component.damage(damage);
	
	#var floating_text = floating_text_scene.instantiate() as Node2D
	#get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text);
	#floating_text.global_position = global_position + (Vector2.UP * 16)
	
	#var format_string = "%0.1f"
	#if round(damage) == damage:
	#	format_string = "%0.0f"
	
	#floating_text.start(str(format_string % damage))
	