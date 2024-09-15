extends Area2D

@export var max_speed: int = 40
@export var acceleration: float = 5

var velocity = Vector2.ZERO
var is_centered;

func _ready():
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)


func on_area_entered(other_area: Area2D):
	pass
	#if other_area is SpawnPoint:
    #	is_centered = true
	

func on_area_exited(other_area: Area2D):
	pass
	#if other_area is SpawnPoint:
	#	is_centered = false
	


func accelerate_to_player():
	var owner_node2d = owner as Node2D;
	if owner_node2d == null:
		return
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return;
	
	#	Target position goes first
	var direction = (player.global_position - owner_node2d.global_position).normalized()
	accelerate_in_direction(direction);


func accelerate_away_from_player():
	var owner_node2d = owner as Node2D;
	if owner_node2d == null:
		return
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return;
	
	#	Target position goes first
	var direction = (player.global_position - owner_node2d.global_position).normalized()
	accelerate_in_direction(-direction);


# if its in the middle itll just return false
func accelerate_to_arena_center():
	var owner_node2d = owner as Node2D;
	if owner_node2d == null:
		return false;
	var arena_manager = get_tree().get_first_node_in_group("arena") as Node
	if arena_manager == null:
		return false;
	var arenas = arena_manager.get_children();
	if arenas == null:
		return false;
	var current_arena = arenas[0] as Node2D
	if current_arena == null:
		return false;

	# Get color rect which is invisible but is to know how large the area is	
	var central_point = current_arena.get_child(0);
	if central_point == null:
		return false;

	# 	Target position goes first
	var direction = (central_point.global_position - owner_node2d.global_position).normalized()
	accelerate_in_direction(direction);

	if is_centered:
		return true;
	else:
		return false;


func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * max_speed;
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))


func decelerate():
	accelerate_in_direction(Vector2.ZERO);


func move(character_body: CharacterBody2D):
	character_body.velocity = velocity;
	character_body.move_and_slide();
	velocity = character_body.velocity


