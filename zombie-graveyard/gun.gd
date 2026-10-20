extends Node2D

const BULLET_SCENE: PackedScene = preload("res://bullet.tscn")

@export var fire_delay: float = 0.15

var can_fire: bool = true


func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())

	if Input.is_action_just_pressed("fire_bullet"):
		fire()


func fire() -> void:
	if not can_fire:
		return

	can_fire = false

	var bullet = BULLET_SCENE.instantiate()


	bullet.dir = global_rotation
	bullet.global_rotation = global_rotation


	get_tree().current_scene.add_child(bullet)


	bullet.global_position = $Node2D.global_position


	await get_tree().create_timer(fire_delay).timeout

	can_fire = true
