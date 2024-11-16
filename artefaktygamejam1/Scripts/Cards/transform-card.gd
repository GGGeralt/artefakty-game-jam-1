class_name TransformClass
extends BaseCard

var texture = preload("res://assets/cards/card-transform.png")
var blocked_texture = preload("res://assets/cards/card-transform-blocked.png")

func _init() -> void:
	_set_card_name("TransformCard")
	
	set_sprite_texture(texture)
	
	print("Class Name: ", name)
