extends Node2D

func _ready() -> void:
	$CombatButton.pressed.connect(_on_combat_button_pressed)

func _on_combat_button_pressed() -> void:
	GameManager.enter_combat()
