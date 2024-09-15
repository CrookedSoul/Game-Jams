extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
#@onready var mob_damage_interval_timer = $DamageIntervalTimer;
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals;
@onready var sprite = $Visuals/Sprite2D;
@onready var hurtbox_component = $HurtBoxComponent
@onready var health_component = $HealthComponent

@export var user_interface: Node;
@export var base_speed = 90
@export var base_acceleration = 25
var max_hp = 6

var current_speed = 0

var current_max_hp = 0;
var movement_vector;

func _ready():
	velocity_component.max_speed = base_speed
	velocity_component.acceleration = base_acceleration
	current_speed = velocity_component.max_speed;

	#mob_damage_interval_timer.timeout.connect(on_mob_damage_interval_timer_timeout);

	health_component.set_max_health(max_hp, false);
	health_component.health_changed.connect(on_health_changed);

	update_health_display();


func _process(delta):
	movement_vector = get_movement_vector();
	var direction = movement_vector.normalized();
	velocity_component.accelerate_in_direction(direction);
	velocity_component.move(self)
	
	var left_right_sign = sign(movement_vector.x)
	var up_down_sign = sign(movement_vector.y)
	if movement_vector.x != 0 || movement_vector.y != 0:
		if up_down_sign != 0:
			if up_down_sign == 1:
				animation_player.play("walk_down")
			else:
				animation_player.play("walk_up")
		elif left_right_sign != 0:
			animation_player.play("walk_side")

		if left_right_sign != 0:
			visuals.scale = Vector2(left_right_sign, 1)
	else:
		animation_player.play("RESET")
		
	


func get_movement_vector():
	# 0 or 1
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left");
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up");
	return Vector2(x_movement, y_movement);


func update_health_display():
	pass
	#user_interface.update_health(health_component.current_health, health_component.max_health)
	#health_bar.value = health_component.get_health_percent();


func on_health_changed():
	update_health_display()
