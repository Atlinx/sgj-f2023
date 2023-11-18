extends Node

@export var entity_body: CharacterBody2D
@export var detection_area: Area2D
@export var navigation_agent: NavigationAgent2D
@export var speed: float = 64
@export var update_position_interval: float = 1
@export var animation_tree: AnimationTree

var _update_position_timer: float = 0
var _player: Node2D

func _ready():
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D):
	var team = body.get_node_or_null("Team")
	if team != null and team.team == Team.TeamType.PLAYER:
		_player = body


func _on_body_exited(body: Node2D):
	if body == _player:
		_player = null


func _process(delta):
	if _player != null:
		_update_position_timer += delta
		if _update_position_timer > update_position_interval:
			navigation_agent.target_position = _player.global_position
			_update_position_timer -= update_position_interval


func _physics_process(delta):
	print("animation_tree.walking: %s" % animation_tree.walking)
	animation_tree.walking = not navigation_agent.is_navigation_finished()
	if not navigation_agent.is_navigation_finished():
		var dir = entity_body.to_local(navigation_agent.get_next_path_position()).normalized()
		entity_body.velocity = dir * speed
		entity_body.move_and_slide()
