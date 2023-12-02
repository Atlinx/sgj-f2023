extends Area2D

signal base_attacked


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.queue_free()
		base_attacked.emit()
