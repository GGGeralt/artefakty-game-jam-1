extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -800.0

@export var projectileHolder:Node2D
@export var ball = load("res://scenes/ball.tscn")
var last_velocityx = 0
var projectile

var timeSlowed:bool=false;

var minDamageBuff:float = 0.1
var maxDamageBuff:float = 1
var actualDamageBuff:float = 1
var changeDamageBuff:float = 33

@onready var cardsManager: Node2D = $Camera2D/CardsManager

func _ready() -> void:
	if cardsManager == null:
		print("Nie znaleziono CardsManager")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and not projectile:
				timeSlowed = true
			else:
				fire_projectile()
				timeSlowed = false
				
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if is_instance_valid(projectile):
				projectile.Return()
			else:
				print("Projectile instance is no longer valid!")
	#elif event is InputEventMouseMotion:

func fire_projectile() -> void:
	if projectile == null:
		projectile = ball.instantiate()
		projectile.global_position = projectileHolder.global_position
		projectile.top_level = true
		
		var card = cardsManager.pop_card()
		
		if card.get_status():
			projectile.SetInitialEffect(card._get_card_name());
		
		projectile.SetInitialVelocity(projectileHolder.global_position.direction_to(get_global_mouse_position()));
		add_child(projectile)
	
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed( 1 ):
		actualDamageBuff = lerpf(actualDamageBuff, minDamageBuff, changeDamageBuff * delta)
	else:
		actualDamageBuff = lerpf(actualDamageBuff, maxDamageBuff, changeDamageBuff/25 * delta)


	if not projectile:
		projectileHolder.visible = true
		projectileHolder.scale = Vector2(actualDamageBuff/5 + 0.3, actualDamageBuff/5 + 0.3)
	else:
		projectileHolder.visible = false
		
		
	if timeSlowed:
		Engine.time_scale = 0.1
	else:
		Engine.time_scale = 1

func _physics_process(delta: float) -> void:
	
	var anim_player : AnimationPlayer = $AnimationPlayer
	var direction_vector = self.get_last_motion()
	print(direction_vector)
	if direction_vector.y != 0:
		if direction_vector.x <= 0:
			anim_player.current_animation = "falling_left"
		elif direction_vector.x > 0:
			anim_player.current_animation = "falling_right"
	elif direction_vector.x < 0:
		anim_player.current_animation = "walking_left"
		last_velocityx = direction_vector.x
	elif direction_vector.x > 0:
		anim_player.current_animation = "walking_right"
		last_velocityx = direction_vector.x
	elif direction_vector == Vector2(0,0):
		if last_velocityx <= 0:
			anim_player.current_animation = "standing_left"
		elif last_velocityx > 0:
			anim_player.current_animation = "standing_right"
	
	projectileHolder.global_position = global_position + (global_position.direction_to(get_global_mouse_position())) * 125;
	#if projectile != null:
	#	projectile.global_position += projectile.global_position.direction_to(get_global_mouse_position()) *25 * delta
	
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
	
	
func damage():
	cardsManager.disable_next_card()
	
	if cardsManager.get_active_cards_count() == 1:
		Manager.totalLegsColected = 0
		get_tree().reload_current_scene()
