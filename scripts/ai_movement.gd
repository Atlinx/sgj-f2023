extends Node

@export var entity_body: CharacterBody2D
@export var detection_area: Area2D
@export var navigation_agent: NavigationAgent2D
@export var speed: float = 64
@export var update_position_interval: float = 1
@export var bullet_prefab: PackedScene
@export var fire_interval = 1
@export var animation_tree: AnimationTree
@export var dropped_heart : DroppedItem

var base_position
var _fire_timer: float

var _update_position_timer: float = 0
var _player: Node2D

func _ready():
	_fire_timer = fire_interval
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)
	dropped_heart.visible = false
	base_position = get_tree().get_first_node_in_group("base").global_position
	call_deferred("_delayed_navigation_setup")

func _delayed_navigation_setup():
	navigation_agent.target_position = base_position
	

func _on_body_entered(body: Node2D):
	var team = body.get_node_or_null("Team")
	if team != null and team.team == Team.TeamType.PLAYER:
		_player = body


func _on_body_exited(body: Node2D):
	if body == _player:
		_player = null
		navigation_agent.target_position = base_position


func _process(delta):
	if _player != null:
		_update_position_timer += delta
		if _update_position_timer > update_position_interval:
			navigation_agent.target_position = _player.global_position
			_update_position_timer -= update_position_interval
		if _fire_timer <= 0:
			var bullet_inst: Bullet = bullet_prefab.instantiate()
			get_tree().get_first_node_in_group("level").add_child(bullet_inst)
			var direction = (_player.global_position - entity_body.global_position).normalized()
			bullet_inst.construct(entity_body, entity_body.global_position, direction)
			_fire_timer = fire_interval
		else:
			_fire_timer -= delta



func _physics_process(_delta):
	animation_tree.walking = not navigation_agent.is_navigation_finished()
	if not navigation_agent.is_navigation_finished():
		var dir = entity_body.to_local(navigation_agent.get_next_path_position()).normalized()
		entity_body.velocity = dir * speed
		entity_body.move_and_slide()


func _on_health_death():
	var root = get_tree().get_first_node_in_group("level")
	dropped_heart.call_deferred("reparent",root)
	dropped_heart.enabled = true

