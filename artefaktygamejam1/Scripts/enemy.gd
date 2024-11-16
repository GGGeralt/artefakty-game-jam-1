extends Node2D

var player
var enemies = []
const ENEMY_SPEED = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_parent().get_parent()
	player = root.find_child("Character")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var playerPosition = player.global_position
	var direction = (player.global_position - self.global_position).normalized()
	self.global_position += direction * ENEMY_SPEED * delta
