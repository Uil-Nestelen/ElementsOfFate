extends Node2D

@onready var battle_manager: BattleManager = $BattleManager
@onready var end_turn_button: Button = $EndTurnButton

func _ready() -> void:
	battle_manager.initialize_battle()
	battle_manager.start_battle()

	$MapButton.pressed.connect(_on_map_button_pressed)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)

func _on_map_button_pressed() -> void:
	battle_manager.end_battle()
	GameManager.return_to_map()

func _on_end_turn_button_pressed() -> void:
	battle_manager.turn_manager.end_player_turn()

func _process(_delta: float) -> void:
	if get_viewport().gui_get_hovered_control() != null:
		battle_manager.movement_controller.clear_path_preview()
		return

	var mouse_position := get_global_mouse_position()

	var tile := battle_manager.grid_manager.get_tile_at_global_position(
		mouse_position
	)

	if tile != null:
		battle_manager.movement_controller.update_path_preview(
			battle_manager.player.grid_coordinate,
			tile.coordinate,
			battle_manager.player.movement_points
		)
	else:
		battle_manager.movement_controller.clear_path_preview()

func _unhandled_input(event: InputEvent) -> void:
	if battle_manager.turn_manager.current_turn != TurnManager.TurnState.PLAYER_TURN:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var mouse_position := get_global_mouse_position()

			var tile := battle_manager.grid_manager.get_tile_at_global_position(
				mouse_position
			)

			if tile != null:
				battle_manager.movement_controller.execute_movement(
					battle_manager.player,
					tile.coordinate
				)

				battle_manager.movement_controller.clear_path_preview()
