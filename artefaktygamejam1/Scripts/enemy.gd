extends StaticBody2D

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
	
	var collision = move_and_collide(direction * ENEMY_SPEED * delta, true)
	if collision:
		var collider = collision.get_collider()
		if not collider.is_in_group("Ignore"):
			if collider.is_in_group("Player"):
				collider.damage()
				queue_free()
				
	self.global_position += direction * ENEMY_SPEED * delta
