extends Node

var battle_timer

var player_turn = true

var player_health = 30
var opponent_health = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	battle_timer = $"../BattleTimer"
	battle_timer.one_shot = true
	battle_timer.wait_time = 1.0

func _on_end_turn_button_pressed() -> void:
	player_turn = false
	
	resolve_player_cards()
	opponent_turn()

func opponent_turn():
	$"../EndTurnButton".disabled = true
	$"../EndTurnButton".visible = false
		
	# Wait one second
	battle_timer.start()
	await battle_timer.timeout
	
	# If can draw a card, draw then wait 1 second
	if $"../OpponentsDeck".oponnent_deck.size() >= 0:
		$"../OpponentsDeck".draw_card()
	
	battle_timer.start()
	await battle_timer.timeout
	#Check if card slots, and if no, then end turn
	
	#play the cards in hand
	
	
	end_opponent_turn()
	if $"../Deck".player_deck.size() >= 0:
		$"../Deck".draw_card()
	

func end_opponent_turn():
	# Reset player deck draw
	$"../EndTurnButton".disabled = false
	$"../EndTurnButton".visible = true
	
	player_turn = true

func damage_opponent(amount):
	opponent_health -= amount
	print("Opponent takes ", amount, " damage.")
	print("Opponent health: ", opponent_health)

	if opponent_health <= 0:
		opponent_health = 0
		print("Player wins!")

func damage_player(amount):
	player_health -= amount
	print("Player takes ", amount, " damage.")
	print("Player health: ", player_health)

	if player_health <= 0:
		player_health = 0
		print("Opponent wins!")
		
func resolve_player_cards():
	var total_damage = 0

	for card_slot in $"../CardSlots".get_children():
		if card_slot.card_in_slot:
			var card = card_slot.card_in_slot

			var attack = int(card.get_node("Attack").text)
			total_damage += attack

			print("Player card attacks for ", attack)

			card.queue_free()
			card_slot.card_in_slot = null

	if total_damage > 0:
		damage_opponent(total_damage)
