class_name BaseCard
extends Node2D

var card_name = null : set = _set_card_name, get = _get_card_name
var sprite: Sprite2D = null
var is_active: bool = true

func enable():
	is_active = true

func disable():
	is_active = false

func get_status():
	return is_active

func _set_card_name(value: String) -> void:
	card_name = value

func _get_card_name() -> String:
	return card_name

func set_sprite_texture(texture: Texture2D) -> void:
	print(texture)
	if sprite:
		sprite.texture = texture
		sprite.scale.x = 1.5
	else:
		sprite = Sprite2D.new()
		sprite.texture = texture
		sprite.scale.x = 1.5
		add_child(sprite)
