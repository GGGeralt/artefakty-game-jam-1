class_name RotateCard
extends BaseCard

var texture = preload("res://assets/cards/card-rotate.png")
var blocked_texture = preload("res://assets/cards/card-rotate-blocked.png")

func _init() -> void:
	_set_card_name("RotateCard")
	
	set_sprite_texture(texture)

	print("Class Name: ", name)
