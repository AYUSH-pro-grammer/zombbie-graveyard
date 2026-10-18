extends Area2D

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("bullets"):
		print("Bullet hit!")

		get_parent().take_damage(10)
		body.queue_free()
