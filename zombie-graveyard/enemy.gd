extends StaticBody2D

@export var initalHp: int = 30
@export var hp: int = initalHp


func die() -> void:
	queue_free()
	
	
func take_damage(amount: int) -> void:
	hp -= amount
	
	print("HP REMAINING: ", hp, "/", initalHp)
	
	if hp <= 0:
		die()
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
