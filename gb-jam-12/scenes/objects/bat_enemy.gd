extends CharacterBody2D

@onready var velocity_component = $VelocityComponent 
@onready var animation_player = $AnimationPlayer 
@onready var visuals = $Visuals
@onready var attack_range_component = $AttackRangeComponent
@onready var health_component = $HealthComponent

@export var attack : PackedScene
@export var attack_cooldown : float = 1
var is_dying = false;

func _ready() -> void:
	health_component.health_changed.connect(on_health_changed);

func _process(delta):
	if GameEvents.dialog_visible:
		return;
		
	if is_dying:
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

	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func on_health_changed():
	if health_component.current_health <= 0:
		is_dying = true;
		animation_player.play("dying")


func finished_dying():
	queue_free();