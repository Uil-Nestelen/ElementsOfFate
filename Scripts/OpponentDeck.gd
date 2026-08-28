extends Node2D

const CARD_SCENE_PATH = "res://Scenes/OpponentCard.tscn"
const CARD_DRAW_SPEED = 0.2
const STARTING_HAND_SIZE = 5

var oponnent_deck = ["FireBolt", "BloodBolt", "IceShard", "FireBolt", "IceShard", "FireBolt", "IceShard", "FireBolt"]
var card_database_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	oponnent_deck.shuffle()
	$"RichTextLabel".text = str(oponnent_deck.size())
	card_database_reference = preload("res://Scripts/CardDatabase.gd")
	for i in range(STARTING_HAND_SIZE):
		draw_card()

func draw_card():
	var card_drawn_name = oponnent_deck[0]
	oponnent_deck.erase(card_drawn_name)
	
	if oponnent_deck.size() == 0:
		$DeckImage.visible = false
		$"RichTextLabel".visible = false
	
	$"RichTextLabel".text = str(oponnent_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://Assets/" + card_drawn_name + ".png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	new_card.get_node("Attack").text = str(card_database_reference.CARDS[card_drawn_name][0])
	new_card.get_node("Health").text = str(card_database_reference.CARDS[card_drawn_name][1])
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	$"../OpponentHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
