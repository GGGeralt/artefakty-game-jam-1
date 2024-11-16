class_name TransformClass
extends BaseCard

func _init() -> void:
	_set_card_name("TransformCard")
	
	var texture = preload("res://Assets/Cards/card-transform.png")
	set_sprite_texture(texture)
	
	print("Class Name: ", name)
