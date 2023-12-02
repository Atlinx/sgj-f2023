extends Node
class_name GameManager

@export var spawn_location_1 : Node2D
@export var spawn_location_2 : Node2D
@onready var player_1 = get_tree().get_first_node_in_group("player1")
@onready var health_1 = player_1.get_node("Health")
@onready var player_2 = get_tree().get_first_node_in_group("player2")
@onready var health_2 = player_2.get_node("Health")
@export var gold : int = 0
@export var base_max_health : int
var base_health
signal base
signal gold_change

func _ready():
	health_1.death.connect(_revive_player_1)
	health_2.death.connect(_revive_player_2)
	player_2.get_node("ItemCollector").get_gold.connect(on_get_gold)
	base_health = base_max_health
	base.emit()

func _process(_delta):
	if Input.is_key_pressed(KEY_Q) and gold >= 10:
		player_1.has_shot = true
		gold -= 10
		gold_change.emit()
	if Input.is_key_pressed(KEY_P) and gold >= 5:
		health_2.heal(30)
		gold -= 5
		gold_change.emit()


func _revive_player_1():
	var revive_time = player_1.revive_timer
	await get_tree().create_timer(revive_time).timeout
	health_1.reset_health()
	player_1.global_position = spawn_location_1.global_position


func _revive_player_2():
	var revive_time = player_2.revive_timer
	await get_tree().create_timer(revive_time).timeout
	health_2.reset_health()
	player_2.global_position = spawn_location_2.global_position


func _on_base_base_attacked():
	base_health -= 1
	base.emit()

func on_get_gold():
	gold += 1
	gold_change.emit()

