extends CanvasLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CollectedLegsLabel.text = "Zebrane nogi: " + str(Manager.totalLegsColected)