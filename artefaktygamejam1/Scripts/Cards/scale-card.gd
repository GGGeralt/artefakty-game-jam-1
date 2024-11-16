class_name ScaleCard
extends BaseCard

var texture = preload("res://assets/cards/card-scale.png")
var blocked_texture = preload("res://assets/cards/card-scale-blocked.png")

func _init() -> void:
	_set_card_name("ScaleCard")
	
	set_sprite_texture(texture)
	
	print("Class Name: ", name)
