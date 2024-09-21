extends CharacterBody2D

@onready var velocity_component = $VelocityComponent 
@onready var animation_player = $AnimationPlayer 
@onready var visuals = $Visuals
@onready var attack_range_component = $AttackRangeComponent
@onready var health_component = $HealthComponent
@onready var hitbox_component = $HitboxComponent
@onready var spawn_spot = $Visuals/SpawnSpot

@export var bat_scene : PackedScene
var is_attacking = false;
var is_dying = false;

func _ready() -> void:
	health_component.health_changed.connect(on_health_changed);

func _process(delta):
	if GameEvents.dialog_visible:
		return;
		
	if is_attacking || is_dying:
		return;
	else:
		animation_player.play("walking")


	if attack_range_component.range_state == GlobalEnums.RangeState.OUT_OF_RANGE:
		velocity_component.accelerate_to_player();
	elif attack_range_component.range_state == GlobalEnums.RangeState.IN_RANGE:
		velocity_component.decelerate()
	elif attack_range_component.range_state == GlobalEnums.RangeState.TOO_CLOSE:
		velocity_component.decelerate()
		
	velocity_component.move(self)
	
	if attack_range_component.range_state == GlobalEnums.RangeState.TOO_CLOSE || attack_range_component.range_state == GlobalEnums.RangeState.IN_RANGE:
		is_attacking = true;
		animation_player.play("attacking")

	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)
		hitbox_component.scale = Vector2(move_sign, 1)


func on_health_changed():
	if health_component.current_health <= 0:
		is_dying = true;
		animation_player.play("dying")


func finished_attacking():
	var mob_instantiated = bat_scene.instantiate()
	mob_instantiated.global_position = spawn_spot.global_position
	get_tree().get_first_node_in_group("foreground_layer").add_child(mob_instantiated)
	is_attacking = false


func finished_dying():
	queue_free();