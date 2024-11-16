extends StaticBody2D

var player
var enemies = []
const ENEMY_SPEED = 100
var direction = 1

@onready var enemyRayCastRight = $RayCast2DRight
@onready var enemyRayCastLeft = $RayCast2DLeft
@onready var enemyAnimatedSprite = $AnimatedSprite2D

func _ready() -> void:	
	var root = get_parent().get_parent()
	player = root.find_child("Character")


func _process(delta: float) -> void:
	var motion = Vector2(direction * ENEMY_SPEED * delta, 0)
	var collision = move_and_collide(motion, true)
	if collision:
		var collider = collision.get_collider()
		if collider and not collider.is_in_group("Ignore"):
			if collider.is_in_group("Player"):
				collider.damage()
				queue_free()
				return 

	# Sprawdzanie kolizji z raycastami
	if enemyRayCastRight.is_colliding():
		direction = -1
		enemyAnimatedSprite.flip_h = true
	elif enemyRayCastLeft.is_colliding():
		direction = 1
		enemyAnimatedSprite.flip_h = false

	# Aktualizacja pozycji
	position += Vector2(direction * ENEMY_SPEED * delta, 0)
