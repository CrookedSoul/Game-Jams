extends Node2D
class_name AttackRangeComponent

@export var attack_range = 175.0;
var player;
var locked = false;
var locked_distance;

var range_state: GlobalEnums.RangeState;

func _ready():
	player = get_tree().get_first_node_in_group("player") as Node2D


func _process(delta):
	if player == null:
		return;
	
	var distance = (player.global_position - global_position).length()
	if locked && distance > 0 && distance < attack_range * 0.2:
		unlock_state()
	elif locked:
		return;

	if distance > attack_range * 0.6 && distance < attack_range * 0.8:
		range_state = GlobalEnums.RangeState.IN_RANGE;
	elif distance < attack_range * 0.6:
		range_state = GlobalEnums.RangeState.TOO_CLOSE;
	else :
		range_state = GlobalEnums.RangeState.OUT_OF_RANGE;
		
	locked_distance = player.global_position - global_position;

func lock_state():
	print("locked State")
	locked = true

func unlock_state():
	print("unlocked State")
	locked = false