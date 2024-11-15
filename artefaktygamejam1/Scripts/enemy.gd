extends Node2D

var player
var enemies = []
const ENEMY_SPEED = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().find_child("Player")
	
	# Wszystkie obiekty przeciwników na planszy
	for child in get_parent().get_children():
		if child.name.begins_with("Enemy"):
			enemies.append(child)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var playerPosition = player.global_position
	
	for enemy in enemies:
		var direction = (player.global_position - enemy.global_position).normalized()
		
		enemy.global_position += direction * ENEMY_SPEED * delta
