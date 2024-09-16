extends Node2D

@export var base_speed = 90
@export var base_acceleration = 25

@export var current_weapon_index = 0	
@export var weapons : Array[ItemData]
@export var apple_item : ItemData

@export var apples_count : int
@export var handgun_ammo : int
@export var shotgun_ammo : int
@export var submachine_ammo : int

var current_item : ItemData

var current_level = 0
var current_hp = 0
var max_hp = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_hp = max_hp
	GameEvents.emit_hp_changed(current_hp)


func change_item():
	if weapons != null && weapons.size() > 0:
		if current_item == apple_item:
			current_weapon_index = 0
			current_item = weapons[0]
		elif current_weapon_index < 2:
			current_weapon_index = current_weapon_index + 1
			if weapons.size() >= current_weapon_index + 1:
				current_item = weapons[current_weapon_index]
			else:
				current_item = apple_item;

	if current_item != null:
		GameEvents.emit_item_changed(current_item);

		if current_item.id == "water_gun":
			GameEvents.emit_ammo_changed(handgun_ammo)
		elif current_item.id == "shotgun":
			GameEvents.emit_ammo_changed(shotgun_ammo)
		elif current_item.id == "submachine":
			GameEvents.emit_ammo_changed(submachine_ammo)
		elif current_item.id == "apple":
			GameEvents.emit_ammo_changed(apples_count)


func on_take_item(item: ItemData):
	if item.is_weapon:
		if weapons.has(item):
			return;
		
		weapons.append(item)
		if item.id == "water_gun":
			current_item = weapons[0]
			GameEvents.emit_item_changed(current_item);
			GameEvents.emit_ammo_changed(handgun_ammo)
	elif item.id == "apple":
		apples_count = apples_count + 1
		if current_item != null && current_item.id == "apple":
			GameEvents.emit_ammo_changed(apples_count)
	elif item.id == "handgun_ammo":
		handgun_ammo = handgun_ammo + 15
		if current_item != null && current_item.id == "water_gun":
			GameEvents.emit_ammo_changed(handgun_ammo)
	elif item.id == "shotgun_ammo":
		shotgun_ammo = shotgun_ammo + 6
		if current_item != null && current_item.id == "shotgun":
			GameEvents.emit_ammo_changed(shotgun_ammo)
	elif item.id == "submachine_ammo":
		submachine_ammo = submachine_ammo + 30
		if current_item != null && current_item.id == "submachine":
			GameEvents.emit_ammo_changed(submachine_ammo)
	

func can_and_use_ammo():
	if PlayerStats.current_item.id == "water_gun":
		if handgun_ammo > 0:
			handgun_ammo = handgun_ammo - 1
		GameEvents.emit_ammo_changed(handgun_ammo)
		return handgun_ammo > 0
	elif PlayerStats.current_item.id == "shotgun":
		if shotgun_ammo > 0:
			shotgun_ammo = shotgun_ammo - 1
		GameEvents.emit_ammo_changed(shotgun_ammo)
		return handgun_ammo > 0
	elif PlayerStats.current_item.id == "submachine":
		if submachine_ammo > 0:
			submachine_ammo = submachine_ammo - 1
		GameEvents.emit_ammo_changed(submachine_ammo)
		return handgun_ammo > 0
	elif PlayerStats.current_item.id == "apple":
		if apples_count > 0 && current_hp < max_hp:
			apples_count = apples_count - 1
		GameEvents.emit_ammo_changed(apples_count)
		return apples_count > 0