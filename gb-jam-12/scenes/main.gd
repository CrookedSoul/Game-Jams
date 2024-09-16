extends Node

@export var ui_margin_container : MarginContainer
@export var dialog_margin_container : MarginContainer
@export var game_view : Node
@export var animation_player : AnimationPlayer
@export var health_bar : TextureRect
@export var ammo_label : Label
@export var equiped_item_icon : TextureRect

var zero_hp = preload("res://assets/0_hearts_16x16.png")
var one_hp = preload("res://assets/1_heart_16x16.png")
var two_hp = preload("res://assets/2_hearts_16x16.png")
var three_hp = preload("res://assets/3_hearts_16x16.png")

var handgun_icon = preload("res://assets/water_gun_16x16.png")
var apple_icon = preload("res://assets/apple_16x16.png")

var scene_1 = preload("res://scenes/scene_1.tscn").instantiate()
var scene_2 = preload("res://scenes/scene_2.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_margin_container.visible = false
	dialog_margin_container.visible = false
	GameEvents.set_ui_visibility.connect(on_set_ui_visibility)
	GameEvents.set_dialog_visibility.connect(on_set_dialog_visibility)
	GameEvents.level_change.connect(on_level_change)
	GameEvents.hp_changed.connect(on_hp_changed)
	GameEvents.ammo_changed.connect(on_ammo_changed)
	GameEvents.item_changed.connect(on_item_changed)


func on_set_ui_visibility(visible: bool):
	ui_margin_container.visible = visible

	
func on_set_dialog_visibility(visible: bool):
	dialog_margin_container.visible = visible

var level_loading: int = 999
func on_level_change(level: int):
	if level_loading != 999:
		return

	level_loading = level
	PlayerStats.current_level = level

	ui_margin_container.visible = false
	animation_player.play("close_in")


func change_level():
	if level_loading == 999:
		return
	animation_player.play("open_up")

	var children = game_view.get_children()
	if children == null:
		return;

	for child in children:
		child.queue_free();
	
	if level_loading == 0:
		pass # should go to start screen
	elif level_loading == 1:
		game_view.add_child(scene_1)
	elif level_loading == 2:
		game_view.add_child(scene_2)
	
	level_loading = 999
	
func show_ui():
	ui_margin_container.visible = true


func on_hp_changed(current_hp: int):
	if current_hp == 0:
		health_bar.texture = zero_hp
	elif current_hp == 1:
		health_bar.texture = one_hp
	elif current_hp == 2:
		health_bar.texture = two_hp
	elif current_hp == 3:
		health_bar.texture = three_hp


func on_item_changed(current_item: ItemData):
	if current_item == null:
		return

	if current_item.id == "water_gun":
		equiped_item_icon.texture = handgun_icon
	elif current_item.id == "shotgun":
		equiped_item_icon.texture = handgun_icon
	elif current_item.id == "submachine":
		equiped_item_icon.texture = handgun_icon
	elif current_item.id == "apple":
		equiped_item_icon.texture = apple_icon


func on_ammo_changed(current_ammo : int):
	ammo_label.text = str(current_ammo)