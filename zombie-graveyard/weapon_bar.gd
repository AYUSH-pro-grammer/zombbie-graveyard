
extends HBoxContainer

@export var gun_controller: Node2D

@onready var slot1: Button = get_node_or_null("Button")
@onready var slot2: Button = get_node_or_null("Button2")
@onready var slot3: Button = get_node_or_null("Button3")


func _ready() -> void:
	if slot1 == null or slot2 == null or slot3 == null:
		push_error("WeaponBar: Check that the buttons are named Button, Button2, Button3 and are children of HBoxContainer.")
		return

	slot1.pressed.connect(_on_slot1_pressed)
	slot2.pressed.connect(_on_slot2_pressed)
	slot3.pressed.connect(_on_slot3_pressed)

	update_selection(1, "Pistol")


func _on_slot1_pressed() -> void:
	if is_instance_valid(gun_controller):
		gun_controller.select_gun(1)


func _on_slot2_pressed() -> void:
	if is_instance_valid(gun_controller):
		gun_controller.select_gun(2)


func _on_slot3_pressed() -> void:
	if is_instance_valid(gun_controller):
		gun_controller.select_gun(3)


func update_selection(index: int, gun_name: String) -> void:
	if slot1 == null or slot2 == null or slot3 == null:
		return

	print("UI updated: ", gun_name)

	set_button_color(slot1, index == 1)
	set_button_color(slot2, index == 2)
	set_button_color(slot3, index == 3)


func set_button_color(button: Button, selected: bool) -> void:
	var style := StyleBoxFlat.new()

	if selected:
		style.bg_color = Color(0.1, 0.65, 0.2)
	else:
		style.bg_color = Color(0.15, 0.15, 0.15)

	style.set_corner_radius_all(6)

	button.add_theme_stylebox_override("normal", style)
	button.add_theme_stylebox_override("hover", style)
	button.add_theme_stylebox_override("pressed", style)
	button.add_theme_stylebox_override("focus", style)
