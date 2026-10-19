
extends CharacterBody2D

@onready var enemySprite: AnimatedSprite2D = $AnimatedSprite2D

@export var initialHp: int = 30
@export var hp: int = 30
@export var speed: float = 90.0
@export var attack_range: float = 30.0
@export var attack_damage: int = 10
@export var attack_cooldown: float = 1.0

var player: Node2D = null

var is_dead: bool = false
var is_hurt: bool = false
var is_attacking: bool = false
var can_attack: bool = true


func _ready() -> void:
	hp = initialHp
	enemySprite.play("idle")


func _physics_process(_delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if is_hurt or is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if player != null and is_instance_valid(player):
		var direction: Vector2 = global_position.direction_to(
			player.global_position
		)

		velocity = direction * speed
		update_facing(direction)

		if global_position.distance_to(player.global_position) <= attack_range:
			velocity = Vector2.ZERO
			move_and_slide()
			attack()
			return

		if enemySprite.animation != "running":
			enemySprite.play("running")
	else:
		velocity = Vector2.ZERO

		if enemySprite.animation != "idle":
			enemySprite.play("idle")

	move_and_slide()


func update_facing(direction: Vector2) -> void:
	# The sprite faces right by default.
	# Flip horizontally when moving left.
	if direction.x < -0.1:
		enemySprite.flip_h = true
	elif direction.x > 0.1:
		enemySprite.flip_h = false


func take_damage(amount: int) -> void:
	if is_dead:
		return

	hp -= amount
	print("HP REMAINING: ", hp, "/", initialHp)

	if hp <= 0:
		die()
		return

	if is_hurt:
		return

	is_hurt = true
	velocity = Vector2.ZERO
	enemySprite.play("hitted")

	await enemySprite.animation_finished

	if is_dead:
		return

	is_hurt = false


func attack() -> void:
	if is_dead or is_hurt or is_attacking or not can_attack:
		return

	if player == null or not is_instance_valid(player):
		return

	is_attacking = true
	can_attack = false
	velocity = Vector2.ZERO

	enemySprite.play("hitting")

	# Wait for the attack animation to finish.
	await enemySprite.animation_finished

	if is_dead:
		return

	# Damage the player if still within attack range.
	if player != null and is_instance_valid(player):
		var distance: float = global_position.distance_to(
			player.global_position
		)

		if distance <= attack_range:
			if player.has_method("take_damage"):
				player.take_damage(attack_damage)

	is_attacking = false

	# Cooldown before the next attack.
	await get_tree().create_timer(attack_cooldown).timeout

	if is_dead:
		return

	can_attack = true


func die() -> void:
	if is_dead:
		return

	is_dead = true
	velocity = Vector2.ZERO
	player = null

	enemySprite.play("die")

	await enemySprite.animation_finished

	queue_free()


func _on_detection_body_entered(body: Node2D) -> void:
	if is_dead:
		return

	if body.is_in_group("player"):
		player = body
		print("Player detected!")


func _on_detection_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		print("Player escaped!")
