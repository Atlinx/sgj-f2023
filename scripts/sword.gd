extends CharacterBody2D


@export var damage: int = 1
@export var team: Team.TeamType





func _on_collision(collision: KinematicCollision2D):
	var body = collision.get_collider()
	if body.is_in_group("hitbox"):
		_on_hitbox_hit(body.get_parent())


func _on_hitbox_hit(body: Node2D):
	var health_node: Health = body.get_node_or_null("Health")
	var team_node: Team = body.get_node_or_null("Team")
	if health_node != null:
		if team_node != null and team_node.team == team:
			return
		health_node.damage(damage)
	else:
		printerr("Expected health to exist on entity with hitbox")

