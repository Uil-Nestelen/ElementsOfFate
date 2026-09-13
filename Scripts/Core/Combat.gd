extends Node2D

@onready var battle_manager: BattleManager = $BattleManager

func _ready() -> void:
	battle_manager.initialize_battle()
	battle_manager.start_battle()

	var path := battle_manager.movement_controller.calculate_path(
	battle_manager.player.grid_coordinate,
	Vector2i(2, 2))

	print("Calculated path: ", path)

	$MapButton.pressed.connect(_on_map_button_pressed)

func _on_map_button_pressed() -> void:
	battle_manager.end_battle()
	GameManager.return_to_map()
