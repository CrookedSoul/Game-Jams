extends Resource
class_name ItemData

@export var id: String;
@export var name: String;
@export var icon : Texture;
@export var is_weapon : bool
@export var time_between_shots : float
@export var bullet_scene : PackedScene
@export var bullet_damage : int 
@export var pick_up_description : Array[String] 