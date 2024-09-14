extends Node2D

@export var animation_player: AnimationPlayer
var button_clicked = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if button_clicked:
		return;

	if (Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right") || Input.is_action_pressed("move_up") || Input.is_action_pressed("move_down") ||
	 	Input.is_action_pressed("b_button") || Input.is_action_pressed("a_button") || Input.is_action_pressed("select_button") || Input.is_action_pressed("start_button")):
		button_clicked = true
		animation_player.play("button_clicked")


func enter_game():
	pass
