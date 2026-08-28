extends Node

var battle_timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	battle_timer = $"../BattleTimer"
	battle_timer.one_shot = true
	battle_timer.wait_time = 1.0

func _on_end_turn_button_pressed() -> void:
	opponent_turn()

func opponent_turn():
	$"../EndTurnButton".disabled = true
	$"../EndTurnButton".visible = false
	
	$"../OpponentsDeck".draw_card()
	
	# Wait one second
	battle_timer.start()
	await battle_timer.timeout
	
	# If can draw a card, draw then wait 1 second
	if $"../OpponentsDeck".oponnent_deck.size() != 0:
		$"../OpponentsDeck".draw_card()
	
	battle_timer.start()
	await battle_timer.timeout
	#Check if card slots, and if no, then end turn
	
	#play the cards in hand
	
	
	end_opponent_turn()

func end_opponent_turn():
	# Reset player deck draw
	$"../EndTurnButton".disabled = false
	$"../EndTurnButton".visible = true
