extends CharacterBody2D
class_name Boss

@onready var velocity_component = $VelocityComponent 
@onready var animation_player = $AnimationPlayer 
@onready var visuals = $Visuals
@onready var attack_range_component = $AttackRangeComponent
@onready var health_component = $HealthComponent
@onready var hitbox_component = $HitboxComponent
@onready var spawn_spot = $Visuals/LaunchingArmSpot
@onready var wall_check_collision = $WallCheckCollisionShape2D

@export var left_position : Node2D
@export var right_position : Node2D
@export var camera : Camera2D

var going_right = false
var is_attacking = false;
var is_dying = false;
var transformed = false;

@export var arm_launch_scene : PackedScene

var dialog : Array[String]
var dialog_fight : Array[String]
func _ready() -> void:
	health_component.health_changed.connect(on_health_changed);
	wall_check_collision.body_entered.connect(on_body_entered);
	dialog.append("Anna?")
	dialog.append("No Anna here")
	dialog.append("Heh, hehehe, HAHAHAHA!")

	dialog_fight.append("WHAT DID YOU DO!?")
	dialog_fight.append("WHERE IS ANNA!?")


func on_body_entered(other_body: Node2D):
	if (other_body.is_in_group("wall")):
		going_right = !going_right

func _process(delta):
	if !transformed:
		return;

	if GameEvents.dialog_visible:
		return;
		
	if is_attacking || is_dying:
		return;
	else:
		animation_player.play("walking")

	if going_right:
		velocity_component.accelerate_to(right_position)
	else:
		velocity_component.accelerate_to(left_position)

	velocity_component.move(self)
	
	if attack_range_component.range_state == GlobalEnums.RangeState.TOO_CLOSE || attack_range_component.range_state == GlobalEnums.RangeState.IN_RANGE:
		is_attacking = true;
		animation_player.play("attacking_swing")

	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)
		hitbox_component.scale = Vector2(move_sign, 1)


func on_health_changed():
	if health_component.current_health <= 0:
		is_dying = true;
		animation_player.play("dying")


func finished_attacking_swing():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return;
		
	spawn_spot.look_at(player.global_position)
	animation_player.play("attacking_launch")


func launch_arm():

	var arm_instantiated = arm_launch_scene.instantiate()
	arm_instantiated.global_position = spawn_spot.global_position
	arm_instantiated.global_rotation = spawn_spot.global_rotation
	get_tree().get_first_node_in_group("foreground_layer").add_child(arm_instantiated)
	is_attacking = false;


func finished_dying():
	GameEvents.emit_level_change(4)
	queue_free();


func start_transforming():
	camera.limit_bottom = -170
	animation_player.play("transformation")
	GameEvents.emit_start_dialog(dialog)


func start_walking():
	transformed = true
	animation_player.play("walking")
	GameEvents.emit_start_dialog(dialog_fight)