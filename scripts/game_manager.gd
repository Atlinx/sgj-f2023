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
@export var tile_map : TileMap
@onready var original_speed = player_2.speed
var base_health

signal wave_comming
signal stop_spawning
signal base
signal gold_change
signal win

#给hero找钱用的
var time : float = 0
var high_land : int = 100

const TILE_LAYER: int = 0
const NAV_LAYER: int = 1
const WALL_TERRAIN_ID: int = 0
const WALKABLE_TERRAIN_ID: int = 3
const HIGH_WALL_TERRAIN_ID : int = 1


func _ready():
	health_1.death.connect(_revive_player_1)
	health_2.death.connect(_revive_player_2)
	player_1.get_node("ItemCollector").get_gold.connect(on_get_gold)
	player_2.get_node("ItemCollector").get_gold.connect(on_get_gold)
	base_health = base_max_health
	base.emit()
	

func _process(_delta):
	
	if Input.is_action_just_pressed("build") and gold >= 5:
		var global_mouse_position = tile_map.get_global_mouse_position()
		var cell_coords = tile_map.local_to_map(tile_map.to_local(global_mouse_position))
		var cell_data = tile_map.get_cell_tile_data(0, cell_coords)
		if cell_data.terrain != 4:
		# 设置当前单元
			gold -= 5
			gold_change.emit()
			tile_map.set_cell(0, cell_coords, 0, Vector2i(12, 2), 0)

			# 设置周围非terrain4的单元
			var radius = 1  # 可以调整半径大小
			var air_cells: Array[Vector2i] = []
			for x in range(cell_coords.x - radius, cell_coords.x + radius + 1):
				for y in range(cell_coords.y - radius, cell_coords.y + radius + 1):
					var current_cell = Vector2i(x, y)

					# 检查单元是否在地图范围内
	#				if tile_map.get_cell_item(0, current_cell) != -1:

						# 获取单元的图块索引
					var tile_data = tile_map.get_cell_tile_data(0, current_cell)
					if tile_data != null :
					# 检查图块索引是否不是terrain4
						if tile_data.terrain != 4:
							# 设置非terrain4的单元
							tile_map.set_cell(0, current_cell, 0, Vector2i(0, 4), 0)
							tile_map.set_cell(1, current_cell, 0, Vector2i(0, 0), -1)

							# 创建一个作为 tile_map 子节点的 Area2D 节点
							var area2d = Area2D.new()
							
							# 将 area2d 的位置设置为覆盖当前瓦片
							area2d.position = tile_map.map_to_local(current_cell)

							# 添加 CollisionShape2D 组件
							var collision_shape = RectangleShape2D.new()
							collision_shape.extents = tile_map.tile_set.tile_size / 2.0  # 设置形状的一半作为半径

							var collision_shape2d = CollisionShape2D.new()
							collision_shape2d.shape = collision_shape

							area2d.add_child(collision_shape2d)
							
							# 将 area2d 添加为 tile_map 的子节点
							tile_map.add_child(area2d)

							# 将 area2d 添加到 highland 组中
							area2d.add_to_group("highland")


	
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
	if Input.is_action_just_pressed("upgrade_defense") and gold>10:
		gold -= 10
		gold_change.emit()
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


