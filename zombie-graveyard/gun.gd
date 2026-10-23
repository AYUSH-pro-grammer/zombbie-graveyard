
extends Node2D

@onready var sprite_gun: AnimatedSprite2D = $AnimatedSprite2D

const BULLET_SCENE: PackedScene = preload("res://bullet.tscn")

@export var weapon_bar: Control

var current_gun: int = 1
var can_fire: bool = true

var gun_names = {
	1: "Pistol",
	2: "SMG",
	3: "Heavy Gun"
}

var gun_damage = {
	1: 10,
	2: 4,
	3: 40
}

var gun_delay = {
	1: 0.4,
	2: 0.1,
	3: 0.8
}

var sprite_name = {
	1: "pistol",
	2: "smg",
	3: "heavy"
}


func _ready() -> void:
	sprite_gun.play(sprite_name[current_gun])

	if weapon_bar:
		weapon_bar.update_selection(
			current_gun,
			gun_names[current_gun]
		)


func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())

	if Input.is_action_just_pressed("weapon_1"):
		select_gun(1)
	elif Input.is_action_just_pressed("weapon_2"):
		select_gun(2)
	elif Input.is_action_just_pressed("weapon_3"):
		select_gun(3)

	if Input.is_action_just_pressed("fire_bullet"):
		fire()


func select_gun(index: int) -> void:
	if not gun_names.has(index):
		return

	current_gun = index

	# Change the gun animation.
	sprite_gun.play(sprite_name[current_gun])

	print("Selected: ", gun_names[current_gun])

	if weapon_bar:
		weapon_bar.update_selection(
			current_gun,
			gun_names[current_gun]
		)

func fire() -> void:
	if not can_fire:
		return

	can_fire = false

	var bullet = BULLET_SCENE.instantiate()

	bullet.damage = gun_damage[current_gun]
	bullet.dir = global_rotation
	bullet.global_rotation = global_rotation

	get_tree().current_scene.add_child(bullet)
	bullet.global_position = $Node2D.global_position

	print(
		"Gun: ", gun_names[current_gun],
		" | Damage: ", gun_damage[current_gun]
	)

	await get_tree().create_timer(
		gun_delay[current_gun]
	).timeout

	can_fire = true
