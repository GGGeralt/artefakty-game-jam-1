extends CharacterBody2D

#Efekt zmieniający szybkość piłki
const SPEED = 300.0

const TRANSFORM_FACTOR = 50.0
const SCALE_FACTOR = 1.0

const COOLDOWN_TIME = 0.5
@onready var timer = Timer.new()

var effect: String = "rotate"
var initialVelocity:Vector2

func _ready() -> void:
	randomize()
	
	add_child(timer)
	timer.wait_time = COOLDOWN_TIME
	timer.one_shot = true
	
	
func SetInitialVelocity(vel:Vector2)->void:
	velocity = vel * SPEED

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if not collider.is_in_group("Ignore"):
			velocity = velocity.bounce(collision.get_normal())
			#Zmiana położenia		
			if effect == "transform" and collider.is_in_group("Transfortable"):
				await cooldown()
				randomize_transform(collider)
			elif effect == "scale" and collider.is_in_group("Scalable"):
				await cooldown()
				randomize_scale(collider)
			elif effect == "rotate" and collider.is_in_group("Rotatable"):
				await cooldown()
				randomize_rotation(collider)

func cooldown():
	print("Start")
	timer.start()
	await timer.timeout
	print("End")

func randomize_transform(collider: CollisionObject2D):
	var random_position = Vector2(
		randf_range(-1 * TRANSFORM_FACTOR, 1 * TRANSFORM_FACTOR),
		randf_range(-1 * TRANSFORM_FACTOR, 1 * TRANSFORM_FACTOR),
	)

	collider.global_transform.origin += Vector2(random_position)	
	
func randomize_scale(collider: CollisionObject2D):
	var random_scale = Vector2(
		randf_range(0.1 * SCALE_FACTOR, 3.0 * SCALE_FACTOR),
		randf_range(0.1 * SCALE_FACTOR, 3.0* SCALE_FACTOR),
	)
	
	collider.scale = Vector2(random_scale)
	
func randomize_rotation(collider):
	var random_angle = randf_range(0, 2 * PI)
	collider.rotation = random_angle
	
