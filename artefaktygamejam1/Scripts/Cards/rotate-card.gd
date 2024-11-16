class_name RotateClass
extends BaseCard

func _init() -> void:
	_set_card_name("RotateCard")
	
	var texture = preload("res://Assets/Cards/card-rotate.png")
	set_sprite_texture(texture)
	
	print("Class Name: ", name)
