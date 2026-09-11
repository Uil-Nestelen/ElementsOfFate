extends Node2D

func _ready() -> void:
	$MapButton.pressed.connect(_on_map_button_pressed)

func _on_map_button_pressed() -> void:
	GameManager.return_to_map()
