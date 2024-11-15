extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var projectileHolder:Node2D
@export var ball = load("res://Scenes/ball.tscn")
var projectile

var timeSlowed:bool=false;

var minDamageBuff:float = 0.1
var maxDamageBuff:float = 1
var actualDamageBuff:float = 1
var changeDamageBuff:float = 33

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				timeSlowed = true
			else:
				fire_projectile()
				timeSlowed = false
				
		#if event.button_index == MOUSE_BUTTON_RIGHT:
	#elif event is InputEventMouseMotion:

func fire_projectile() -> void:
	if projectile == null:
		projectile = ball.instantiate()
		projectile.global_position = projectileHolder.global_position
		projectile.top_level = true
		add_child(projectile)
	
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed( 1 ):
		actualDamageBuff = lerpf(actualDamageBuff, minDamageBuff, changeDamageBuff * delta)
	else:
		actualDamageBuff = lerpf(actualDamageBuff, maxDamageBuff, changeDamageBuff/25 * delta)
		
	projectileHolder.scale = Vector2(actualDamageBuff/5 + 0.3, actualDamageBuff/5 + 0.3)
		
	if timeSlowed:
		Engine.time_scale = 0.1
	else:
		Engine.time_scale = 1

func _physics_process(delta: float) -> void:
	
	projectileHolder.global_position = global_position + (global_position.direction_to(get_global_mouse_position())) * 100;
	if projectile != null:
		projectile.global_position += projectile.global_position.direction_to(get_global_mouse_position()) *25 * delta
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))
