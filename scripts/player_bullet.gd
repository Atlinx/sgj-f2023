extends CharacterBody2D
class_name PlayerBullet

signal death()

@export var damage: int = 1
@export var speed: float = 1500
@export var lifetime: float = 5
@export var team: Team.TeamType
var damaged_entity: bool = false
var entity_owner: Node
var enter_high_land : bool = false
var _is_dead : bool = false
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
	var shooter = get_tree().get_first_node_in_group("shooter")
	if entity_owner != shooter:
		set_collision_mask_value(2,false)
		set_collision_layer_value(1,false)
		add_to_group("PassingBullet")
	if entity_owner.on_terrain == 3:
		set_collision_mask_value(3,true)

func _physics_process(delta):
	var shooter = get_tree().get_first_node_in_group("shooter")
	
	if is_in_group("PassingBullet"):
		global_position = global_position.move_toward(shooter.global_position, delta*speed)
	
	var collision: KinematicCollision2D = move_and_collide(_direction * speed * delta)
	if collision != null:
		_on_collision(collision)
	
	_life_timer += delta
	if _life_timer > lifetime:
		_on_death(false)
		




func _on_collision(collision: KinematicCollision2D):
	if _is_dead:
		return
	var body = collision.get_collider()
	if body.is_in_group("wall"):
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
	_is_dead = true

func _on_area_2d_area_exited(area):
	if area.is_in_group("highland"):
		set_collision_mask_value(3,true)
