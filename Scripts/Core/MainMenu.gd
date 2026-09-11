extends Node2D

func _ready() -> void:
	$StartButton.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed() -> void:
	GameManager.start_new_game()
