class_name ScaleCard
extends BaseCard

func _init() -> void:
	_set_card_name("ScaleCard")
	
	var texture = preload("res://assets/cards/card-scale.png")
	set_sprite_texture(texture)
	
	print("Class Name: ", name)
