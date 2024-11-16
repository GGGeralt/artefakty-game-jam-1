extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("OKOK")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Character":
		if Manager.totalLegsColected == 4:
			$AnimatedSprite2D.play("animation")
			
@onready var hud: CanvasLayer = $"../../../Hud"

func _on_animated_sprite_2d_animation_finished() -> void:
	if Manager.totalLegsColected == 4:
		Manager.totalLegsColected = 0
		hud.find_child("blabla").visible = true
		get_tree().paused = true
