extends CharacterBody2D
class_name Bullet


signal death()

@export var damage: int = 1
@export var speed: float = 1500
@export var lifetime: float = 5
@export var team: Team.TeamType

var damaged_entity: bool = false
var entity_owner: Node

var _direction: Vector2
var _life_timer: float = 0


func construct(_entity_owner: Node, initial_position: Vector2, direction: Vector2):
	entity_owner = _entity_owner
	var owner_team_node = entity_owner.get_node_or_null("Team")
	if owner_team_node != null:
		team = owner_team_node.team
	add_collision_exception_with(_entity_owner)
	global_position = initial_position
	_direction = direction


func _physics_process(delta):
	var collision: KinematicCollision2D = move_and_collide(_direction * speed * delta)
	if collision != null:
		_on_collision(collision)
	
	_life_timer += delta
	if _life_timer > lifetime:
		_on_death(false)


func _on_collision(collision: KinematicCollision2D):
	var body = collision.get_collider()
	if body.is_in_group("hitbox"):
		_on_hitbox_hit(body.get_parent())
	elif body.is_in_group("wall"):
		global_position = collision.get_position()
		_on_death(false)


func _on_hitbox_hit(body: Node2D):
	var health_node: Health = body.get_node_or_null("Health")
	var team_node: Team = body.get_node_or_null("Team")
	if health_node != null:
		if team_node != null and team_node.team == team:
			return
		health_node.damage(damage)
		_on_death(true)
	else:
		printerr("Expected health to exist on entity with hitbox")


func _on_death(_damaged_entity: bool):
	damaged_entity = _damaged_entity
	death.emit()
	queue_free()
