
extends CharacterBody2D

@export var speed: float = 2000.0

var damage: int = 10
var dir: float = 0.0
var spritePlay = ""


func _physics_process(delta: float) -> void:
	velocity = Vector2.RIGHT.rotated(dir) * speed

	var collision = move_and_collide(velocity * delta)

	if collision:
		var target = collision.get_collider()

		if target is Node and target.is_in_group("enemies"):
			if target.has_method("take_damage"):
				target.take_damage(damage)
				print(spritePlay)

		queue_free()
