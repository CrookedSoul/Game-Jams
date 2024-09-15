extends Node

signal level_change(level: int)
signal player_damaged()
signal enemy_killed()
signal set_ui_visibility(visible: bool)

func emit_player_damaged():
	player_damaged.emit();


func emit_level_change(level: int):
	level_change.emit(level)


func emit_set_ui_visibility(visible: bool):
	set_ui_visibility.emit(visible);


func emit_enemy_killed():
	# Might need to add a parameter enemy scene but for now just this
	enemy_killed.emit();
