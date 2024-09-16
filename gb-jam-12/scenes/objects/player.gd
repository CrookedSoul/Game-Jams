extends CharacterBody2D
class_name Player

@onready var velocity_component = $VelocityComponent
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals;
@onready var sprite = $Visuals/Sprite2D;
@onready var hurtbox_component = $HurtBoxComponent
@onready var health_component = $HealthComponent
@onready var show_interactable_component = $ShowInteractable

@export var user_interface: Node;
var movement_vector;
var player_can_interact = false
var can_attack = true
var can_change_item = true
var previous_hp = 0

@onready var item_change_timer = $ItemChangeTimer
@onready var cooldown_timer = $CooldownTimer
@onready var launch_position = $LaunchPosition

func _ready():
	GameEvents.player_can_interact.connect(on_player_can_interact)
	GameEvents.take_item.connect(PlayerStats.on_take_item)
	#GameEvents.player_damaged.connect(on_player_damaged)

	cooldown_timer.timeout.connect(on_timer_timeout);
	item_change_timer.timeout.connect(on_item_change_timeout);

	velocity_component.max_speed = PlayerStats.base_speed
	velocity_component.acceleration = PlayerStats.base_acceleration

	health_component.set_max_health(PlayerStats.current_hp, false);
	health_component.health_changed.connect(on_health_changed);

	update_health_display();

func on_timer_timeout():
	can_attack = true;


func on_item_change_timeout():
	can_change_item = true;


func on_health_changed():
	GameEvents.emit_hp_changed(health_component.current_health)


func _process(delta):
	if previous_hp != PlayerStats.current_hp:
		previous_hp = PlayerStats.current_hp
		GameEvents.emit_hp_changed(PlayerStats.current_hp)

	show_interactable_component.visible = player_can_interact
	if player_can_interact && Input.is_action_pressed("b_button"):
		GameEvents.emit_interact_with_item()
	elif !player_can_interact && Input.is_action_pressed("b_button"):
		on_use_item()
	
	if can_change_item && Input.is_action_pressed("a_button"):
		can_change_item = false
		item_change_timer.start()
		PlayerStats.change_item()

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
				launch_position.position = Vector2(0, 16)
				launch_position.global_rotation = deg_to_rad(90)
			else:
				animation_player.play("walk_up")
				launch_position.position = Vector2(0, -16)
				launch_position.global_rotation = deg_to_rad(270)
		elif left_right_sign != 0:
			animation_player.play("walk_side")
			launch_position.position  = Vector2(16 * left_right_sign, 0)
			if left_right_sign == -1:
				launch_position.global_rotation = deg_to_rad(180)
			else:
				launch_position.global_rotation = deg_to_rad(0)

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

			

func on_use_item():
	if PlayerStats.current_item == null:
		return

	if PlayerStats.current_item.is_weapon && can_attack:
		if !PlayerStats.can_and_use_ammo():
			return

		var foreground_layer = get_tree().get_first_node_in_group("foreground_layer");
		var projectile_instance = PlayerStats.current_item.bullet_scene.instantiate()
		foreground_layer.add_child(projectile_instance)
		projectile_instance.is_enemy_projectile = false
		projectile_instance.global_rotation = launch_position.global_rotation
		projectile_instance.hitbox_component.damage = PlayerStats.current_item.bullet_damage;
		cooldown_timer.wait_time = PlayerStats.current_item.time_between_shots;
		projectile_instance.global_position = launch_position.global_position
		can_attack = false;
		cooldown_timer.start()
	
	elif PlayerStats.current_item.id == "apple":
		if !PlayerStats.can_and_use_ammo():
			health_component.heal(1)



func on_player_can_interact(can_interact: bool):
	player_can_interact = can_interact

