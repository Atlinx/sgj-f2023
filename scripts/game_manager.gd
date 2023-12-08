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
@export var level_timer : float
@onready var original_speed = player_2.speed
var base_health
signal wave_comming
signal stop_spawning
signal base
signal gold_change
signal win
#给hero找钱用的
var time : float = 0

func _ready():
	health_1.death.connect(_revive_player_1)
	health_2.death.connect(_revive_player_2)
	player_2.get_node("ItemCollector").get_gold.connect(on_get_gold)
	base_health = base_max_health
	base.emit()
	

func _process(_delta):
	if level_timer > 0:
		level_timer -= _delta


	if Input.is_action_just_pressed("get_bullet") and gold >= 10:
		gold -= 10
		gold_change.emit()
		player_1.has_shot += 1



	if Input.is_action_just_pressed("hero_heal") and gold >= 5:
		if player_2.alive == true:
			health_2.heal(30)
			gold -= 5
			gold_change.emit()


	if Input.is_action_just_pressed("shooter_heal") and gold >= 5:
		if player_1.alive == true:
			health_1.heal(30)
			gold -= 5
			gold_change.emit()


	if level_timer <= 0:
		stop_spawning.emit()
		var enemies = get_tree().get_nodes_in_group("enemy")
		if enemies.size() == 0:
			win.emit()

	if player_2.velocity == Vector2.ZERO :
		time += _delta
		if time >= 3:
			time = 0
			gold += 2
			gold_change.emit()
	else:
		player_2.speed = original_speed


	if Input.is_action_just_pressed("upgrade_collection"): 
		var collector = player_2.get_node("ItemCollector")
		if collector.scale < Vector2(4,4) and gold >= 10:
			gold -= 10
			gold_change.emit()
			collector.scale *= 1.5
			print(player_2.get_node("ItemCollector").scale)
			collector.show()
			await get_tree().create_timer(1).timeout
			collector.hide()

		else:
			collector.show()
			await get_tree().create_timer(1).timeout
			collector.hide()
	if Input.is_action_just_pressed("upgrade_defense"):
		health_2.defense += 5


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
	gold += 5
	gold_change.emit()

func on_enemy_death():
	pass

func slime_wave():
	wave_comming.emit()
