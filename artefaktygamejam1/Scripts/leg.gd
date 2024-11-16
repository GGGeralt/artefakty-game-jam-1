extends Area2D

func _on_body_entered(body: Node2D) -> void:
	Manager.totalLegsColected += 1
	queue_free()
