extends CharacterBody2D

#Efekt zmieniający szybkość piłki
const SPEED = 300.0

const TRANSFORM_FACTOR = 50.0
const SCALE_FACTOR = 1.0

const COOLDOWN_TIME = 0.5
@onready var timer = Timer.new()

var effect: String = ""
var initialVelocity:Vector2
var lastVelocity:Vector2
var isReturning:bool

func _ready() -> void:
	randomize()
	
	add_child(timer)
	timer.wait_time = COOLDOWN_TIME
	timer.one_shot = true
	
func Return()->void:
	isReturning = true
	
func SetInitialEffect(val:String)->void:
	effect = val
	
func SetInitialVelocity(vel:Vector2)->void:
	velocity = vel * SPEED

func _process(delta: float) -> void:
	if isReturning:
		if get_node("CollisionShape2D").process_mode != Node.PROCESS_MODE_DISABLED:
			get_node("CollisionShape2D").process_mode = Node.PROCESS_MODE_DISABLED
		velocity = global_position.direction_to(get_parent().global_position) * SPEED

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if not collider.is_in_group("Ignore"):
			velocity = velocity.bounce(collision.get_normal())
			#Zmiana położenia		
			if effect == "TransformCard" and collider.is_in_group("Transfortable"):
				await cooldown()
				randomize_transform(collider)
			elif effect == "ScaleCard" and collider.is_in_group("Scalable"):
				await cooldown()
				randomize_scale(collider)
			elif effect == "RotateCard" and collider.is_in_group("Rotatable"):
				await cooldown()
				randomize_rotation(collider)
			elif collider.is_in_group("Player"):
				print("PLAYER")
				queue_free()

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
	
