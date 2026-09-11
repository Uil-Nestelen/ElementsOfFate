extends Node2D

@onready var battle_manager: BattleManager = $BattleManager

func _ready() -> void:
	battle_manager.initialize_battle()
	battle_manager.start_battle()
	
	$MapButton.pressed.connect(_on_map_button_pressed)

func _on_map_button_pressed() -> void:
	battle_manager.end_battle()
	GameManager.return_to_map()
