extends Node
class_name GameManager

@export var spawn_location_1 : Node2D
@onready var player_1 = get_tree().get_first_node_in_group("player1")
@onready var health_1 = player_1.get_node("Health")
@onready var player_2 = get_tree().get_first_node_in_group("player2")
@onready var health_2 = player_2.get_node("Health")

func _ready():
	health_1.death.connect(_revive_player_1)
	health_2.death.connect(_revive)

func _process(_delta):
	if Input.is_key_pressed(KEY_BACKSPACE):
		get_tree().reload_current_scene()

func on_enemy_death():
	pass

func _revive_player_1():
	var revive_time = player_1.revive_timer
	await get_tree().create_timer(revive_time).timeout
	health_1.reset_health()
	player_1.global_position = spawn_location_1.global_position


func _revive():
	pass
	

