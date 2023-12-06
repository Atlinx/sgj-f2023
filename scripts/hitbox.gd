extends Area2D


func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.has_method("_on_hitbox_hit"):
		body._on_hitbox_hit(get_parent())

