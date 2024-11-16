extends Node

const TransformCard = preload("Cards/transform-card.gd")
const RotateCard = preload("Cards/rotate-card.gd")
const ScaleCard = preload("Cards/scale-card.gd")

const CARD_OFFSET_X = 150
const CARD_SCALE_X = 0.5
const CARD_SCALE_Y = 1

var cards: Array = [
	TransformCard.new(),
	RotateCard.new(),
	ScaleCard.new(),
	RotateCard.new(),
	ScaleCard.new(),
]

func _ready() -> void:		
	for i in range(cards.size()):
		add_child(cards[i])
		
	reposition_cards()
		
func pop_card():
	var first_card = cards[0]
	cards.remove_at(0)
	cards.append(first_card)
	reposition_cards()

func reposition_cards():
	var viewport_size = Vector2(get_viewport().size.x, get_viewport().size.y)
	var camera = get_viewport().get_camera_2d()
	var camera_size = viewport_size / camera.zoom
	var bottom_center = camera.position + Vector2(0, camera_size.y / 2)
	
	var total_width = (cards.size() - 1) * CARD_OFFSET_X
	var start_x = bottom_center.x - total_width / 2
	
	for i in range(cards.size()):
		var card = cards[i]
		card.position = Vector2(start_x + i * CARD_OFFSET_X, bottom_center.y)
		card.scale.x = CARD_SCALE_X
		card.scale.y = CARD_SCALE_Y
	