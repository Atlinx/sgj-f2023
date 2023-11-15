extends Area2D
class_name Bullet


signal death()

@export var damage: int = 1
@export var speed: float = 1500
@export var lifetime: float = 5
@export var team: Team.TeamType

var damaged_entity: bool = false
var bullet_owner: Node

var _direction: Vector2
var _life_timer: float = 0


func _ready():
	body_entered.connect(_on_body_entered)


func construct(_bullet_owner: Node, initial_position: Vector2, direction: Vector2):
	bullet_owner = _bullet_owner
	global_position = initial_position
	_direction = direction


func _process(delta):
	position += _direction * speed * delta
	_life_timer += delta
	if _life_timer > lifetime:
		_on_death(false)


func _on_body_entered(body: Node2D):
	var health_node: Health = body.get_node_or_null("Health")
	var team_node: Team = body.get_node_or_null("Team")
	if health_node != null:
		if team_node != null and team_node.team == team:
			return
		health_node.damage(damage)
		_on_death(true)
		return
	elif body.is_in_group("wall"):
		_on_death(false)


func _on_death(_damaged_entity: bool):
	damaged_entity = _damaged_entity
	death.emit()
	queue_free()
