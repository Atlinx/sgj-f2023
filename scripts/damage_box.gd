@tool
extends Area2D


@export var damage: int = 1
@export var team: Team.TeamType
@export var entity_owner: Node
@export var damage_interval: float = 1

# [body: Node2D]: timer: float
var _bodies_inside = {}


func _ready():
	if Engine.is_editor_hint():
		return
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _on_area_exited(area: Area2D):
	var body = area.get_parent()
	if body in _bodies_inside:
		_bodies_inside.erase(body)


func _on_area_entered(area: Area2D):
	if area.is_in_group("hitbox"):
		var body = area.get_parent()
		if not body in _bodies_inside:
			_bodies_inside[body] = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		if entity_owner == null:
			entity_owner = get_parent()
		return
	
	for body in _bodies_inside:
		if _bodies_inside[body] > damage_interval:
			var health_node: Health = body.get_node_or_null("Health")
			var team_node: Team = body.get_node_or_null("Team")
			if health_node != null:
				if team_node != null and team_node.team == team:
					_bodies_inside[body] -= damage_interval
					continue
				health_node.damage(damage)
				_bodies_inside[body] = 0
			else:
				printerr("Expected health to exist on entity with hitbox")
			_bodies_inside[body] -= damage_interval
		else:
			_bodies_inside[body] += delta
