extends Node

@export var ui_margin_container : MarginContainer
@export var dialog_margin_container : MarginContainer
@export var game_view : Node
@export var animation_player : AnimationPlayer
@export var health_bar : TextureRect
@export var ammo_label : Label
@export var equiped_item_icon : TextureRect
@export var dialog_rich_text_label : RichTextLabel

var zero_hp = preload("res://assets/0_hearts_16x16.png")
var one_hp = preload("res://assets/1_heart_16x16.png")
var two_hp = preload("res://assets/2_hearts_16x16.png")
var three_hp = preload("res://assets/3_hearts_16x16.png")

var handgun_icon = preload("res://assets/water_gun_16x16.png")
var shotgun_icon = preload("res://assets/shotgun_32x16.png")
var submachine_icon = preload("res://assets/submachine_16x16.png")
var apple_icon = preload("res://assets/apple_16x16.png")

var scene_1 = preload("res://scenes/scene_1.tscn")
var scene_2 = preload("res://scenes/scene_2.tscn")
var scene_3 = preload("res://scenes/scene_3.tscn")
var scene_4 = preload("res://scenes/scene_3.tscn")

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
	GameEvents.start_dialog.connect(on_start_dialog)
	GameEvents.continue_dialog.connect(on_continue_dialog)
	GameEvents.retry_level.connect(on_retry_level)


func on_set_ui_visibility(visible: bool):
	GameEvents.ui_visible = visible
	ui_margin_container.visible = visible

	
func on_set_dialog_visibility(visible: bool):
	dialog_margin_container.visible = visible

var level_loading: int = 999
func on_level_change(level: int):
	if level_loading != 999:
		return

	level_loading = level
	PlayerStats.current_level = level

	PlayerStats.checkpoint_apples = PlayerStats.apples_count
	PlayerStats.checkpoint_handgun = PlayerStats.handgun_ammo
	PlayerStats.checkpoint_submachine = PlayerStats.submachine_ammo
	PlayerStats.checkpoint_shotgun = PlayerStats.shotgun_ammo
	PlayerStats.checkpoint_hp = PlayerStats.current_hp
	PlayerStats.checkpoint_items = PlayerStats.weapons

	GameEvents.ui_visible = false
	ui_margin_container.visible = false
	animation_player.play("close_in")


func change_level():
	if level_loading == 999:
		return
	animation_player.play("open_up")

	var children = game_view.get_children()
	for child in children:
		child.queue_free();

	if level_loading == 0:
		pass # should go to start screen
	elif level_loading == 1:
		game_view.add_child(scene_1.instantiate())
	elif level_loading == 2:
		game_view.add_child(scene_2.instantiate())
	elif level_loading == 3:
		game_view.add_child(scene_3.instantiate())
	elif level_loading == 4:
		game_view.add_child(scene_4.instantiate())
	
	level_loading = 999


func on_retry_level():
	PlayerStats.apples_count = PlayerStats.checkpoint_apples 
	PlayerStats.handgun_ammo = PlayerStats.checkpoint_handgun
	PlayerStats.submachine_ammo = PlayerStats.checkpoint_submachine
	PlayerStats.shotgun_ammo = PlayerStats.checkpoint_shotgun
	PlayerStats.current_hp = PlayerStats.checkpoint_hp 
	PlayerStats.weapons = PlayerStats.checkpoint_items 

	GameEvents.emit_level_change(PlayerStats.current_level)


	
func show_ui():
	GameEvents.ui_visible = true
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
		equiped_item_icon.texture = shotgun_icon
	elif current_item.id == "submachine":
		equiped_item_icon.texture = submachine_icon
	elif current_item.id == "apple":
		equiped_item_icon.texture = apple_icon


func on_ammo_changed(current_ammo : int):
	ammo_label.text = str(current_ammo)


var current_dialog : Array[String]
var current_dialog_index : int
func on_start_dialog(text: Array[String]):
	if text == null || text.size() < 1:
		return 

	current_dialog = text
	dialog_rich_text_label.text = current_dialog[0]
	current_dialog_index = 0
	dialog_margin_container.visible = true
	GameEvents.dialog_visible = true;


func on_continue_dialog():
	if current_dialog.size() > current_dialog_index + 1:
		current_dialog_index = current_dialog_index + 1
		dialog_rich_text_label.text = current_dialog[current_dialog_index]
	else:
		current_dialog_index = 0
		dialog_margin_container.visible = false
		GameEvents.dialog_visible = false;