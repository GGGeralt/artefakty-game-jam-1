extends CharacterBody2D

#Efekt zmieniający szybkość piłki
const SPEED = 300.0

const TRANSFORM_FACTOR = 64.0
const SCALE_FACTOR = 1.0

const COOLDOWN_TIME = 0.3
@onready var timer = Timer.new()

var effect: String = ""
var initialVelocity:Vector2
var lastVelocity:Vector2
var isReturning:bool

var hits_counter:int = 0
var max_hits:int = 4

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
	if hits_counter >= max_hits:
		if isReturning:
			self.global_position += velocity * delta
			var collision = move_and_collide(velocity * delta, true)
			
			if collision:
				if collision.get_collider().is_in_group("Player"):
					queue_free()
		return
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if not collider.is_in_group("Ignore"):
			velocity = velocity.bounce(collision.get_normal())
			#Zmiana położenia		
			if effect == "TransformCard" and collider.is_in_group("Transfortable"):
				hits_counter += 1
				await cooldown()
				randomize_transform(collider)
			elif effect == "ScaleCard" and collider.is_in_group("Scalable"):
				hits_counter += 1
				await cooldown()
				randomize_scale(collider)
			elif effect == "RotateCard" and collider.is_in_group("Rotatable"):
				hits_counter += 1
				await cooldown()
				randomize_rotation(collider)
			elif collider.is_in_group("Player"):
				queue_free()
			elif collider.is_in_group("Enemy"):
				collider.queue_free()

func cooldown():
	timer.start()
	await timer.timeout

func randomize_transform(collider: CollisionObject2D):
	var random_position = Vector2(
		get_random_value() * TRANSFORM_FACTOR,
		get_random_value() * TRANSFORM_FACTOR
	)

	collider.global_transform.origin += Vector2(random_position)	
	
func randomize_scale(collider: CollisionObject2D):
	var random_scale = Vector2(
		get_random_scale() * SCALE_FACTOR,
		get_random_scale() * SCALE_FACTOR
	)
	
	collider.scale = Vector2(random_scale)
	
func randomize_rotation(collider):
	collider.rotation = get_random_angle()
	
func get_random_value():
	return randi() % 5 + 1
	
func get_random_scale():
	# Utwórz tablicę wartości od 0.1 do 2.0 ze skokiem 0.2
	var values = []
	for i in range(11): # 11, bo (2.0 - 0.1) / 0.2 + 1
		values.append(0.1 + i * 0.2)
	
	# Wybierz losową wartość z tablicy
	return values[randi() % values.size()]
	
func get_random_angle():
	# Zakres kątów od 15 do 75
	var angles = []
	for angle in range(15, 76, 14): # 76, ponieważ range kończy się na n-1
		angles.append(angle)

	# Losowy wybór z dostępnych kątów
	return angles[randi() % angles.size()]
