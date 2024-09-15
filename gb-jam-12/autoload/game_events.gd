extends Node

signal level_change(level: int)
signal take_item(item : ItemData)
signal player_damaged()
signal player_can_interact(can_interact: bool)
signal interact_with_item()
signal enemy_killed()
signal set_ui_visibility(visible: bool)
signal set_dialog_visibility(visible: bool)

func emit_player_damaged():
	player_damaged.emit();


func emit_take_item(item : ItemData):
	take_item.emit(item);


func emit_player_can_interact(can_interact: bool):
	player_can_interact.emit(can_interact);


func emit_interact_with_item():
	interact_with_item.emit()


func emit_level_change(level: int):
	level_change.emit(level)


func emit_set_ui_visibility(visible: bool):
	set_ui_visibility.emit(visible);


func emit_set_dialog_visibility(visible: bool):
	set_dialog_visibility.emit(visible);


func emit_enemy_killed():
	# Might need to add a parameter enemy scene but for now just this
	enemy_killed.emit();
