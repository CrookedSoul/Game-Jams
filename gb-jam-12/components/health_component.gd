extends Node
class_name HealthComponent

signal died
signal health_changed

@export var is_player = false;
@export var max_health: float = 10;
var current_health;

func _ready():
	current_health = max_health;


func get_percentage():
	return current_health/max_health * 100

func set_max_health(new_max_health: float, is_level_up: bool):
	max_health = new_max_health;

	if (!is_level_up):
		current_health = max_health;


func damage(damage_ammount: float):
	# Not allow negative amonut
	if is_player:
		GameEvents.emit_player_damaged()
		
	current_health = max(current_health - damage_ammount, 0);
	health_changed.emit();
	Callable(check_death).call_deferred();

	
func heal(heal_ammount: float):
	if (current_health == max_health):
		return

	current_health = current_health + heal_ammount;
	health_changed.emit();


func get_health_percent():
	if max_health <= 0:
		return 0;
	
	return min(current_health / max_health, 1);


func check_death():
	if current_health == 0:
		died.emit();
		if !is_player:
			GameEvents.emit_enemy_killed();
		owner.queue_free();
