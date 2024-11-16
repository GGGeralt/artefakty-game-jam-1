extends Node2D

@export var enemy_scene : PackedScene = load("res://scenes/enemy.tscn")
@export var spawn_distance : float = 2  # Odległość od kamery, gdzie będą się pojawiały wrogowie
@export var spawn_interval : float = 1  # Czas pomiędzy respawnami

var camera : Camera2D
var spawn_timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Znajdź kamerę w scenie
	var camera = get_viewport().get_camera_2d()

	# Timer do respawnów wrogów
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.autostart = true
	spawn_timer.connect("timeout", Callable(self, "_on_SpawnTimer_timeout"))
	add_child(spawn_timer)

# Funkcja do generowania wroga
func _spawn_enemy():
	print("Spawn")
	# Rozmiar widoku kamery
	var screen_size = get_viewport().size
	var spawn_pos = Vector2.ZERO

	# Losowanie pozycji poza ekranem (poza kamerą)
	if randf() < 0.5:
		spawn_pos.x = (-spawn_distance if randf() < 0.5 else screen_size.x + spawn_distance)
		spawn_pos.y = randf() * screen_size.y
	else:
		spawn_pos.x = randf() * screen_size.x
		spawn_pos.y = (-spawn_distance if randf() < 0.5 else screen_size.y + spawn_distance)

	# Instancjonowanie wroga i ustawienie jego pozycji
	var enemy = enemy_scene.instantiate()
	enemy.position = spawn_pos
	add_child(enemy)

# Funkcja wywoływana co pewien czas przez timer
func _on_SpawnTimer_timeout():
	_spawn_enemy()
