extends CharacterBody2D



var character_speed: int = 500
var speed_up: int = 100
var slowdown: int = 6

func _ready() -> void:
	pass
	
	
func move_state() -> void:
	var move_vector:Vector2
	
	move_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	
	if move_vector != Vector2.ZERO:
		
		move_vector = move_vector.normalized()
		velocity = velocity.move_toward(move_vector*character_speed/2, speed_up)

	else:
		velocity = velocity.move_toward(Vector2.ZERO, slowdown)
		pass 
	
	move_and_slide()
	

func _physics_process(delta: float) -> void:


	move_state()
	
	
	
	
