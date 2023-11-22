extends Node

@export var enemy_prefabs: Array[PackedScene]
@export var tile_map: TileMap
@export var game_manager: GameManager
@export var intial_enemy_amount : int = 0

var has_executed_code = false
var _spawnable_cells: Array[Vector2i] = []

const WALL_TERRAIN_ID: int = 0

func _ready():
	for cell in tile_map.get_used_cells(0):
		var tile_data = tile_map.get_cell_tile_data(0, cell)
		if tile_data.terrain != WALL_TERRAIN_ID:
			_spawnable_cells.append(cell)


func _get_random_cells(amount: int) -> Array[Vector2i]:
	var temp_spawnable_cells = _spawnable_cells.duplicate() 
	var valid_cells: Array[Vector2i] = []
	for i in amount:
		var valid_cell_index = randi() % temp_spawnable_cells.size()
		valid_cells.append(temp_spawnable_cells[valid_cell_index])
		temp_spawnable_cells.remove_at(valid_cell_index)
	return valid_cells


func _on_enemy_death():
	game_manager.on_enemy_death()
	


func _process(delta):
	# 获取 "MySceneGroup" 组的所有实例
	if has_executed_code == false:
		var cells_intial = _get_random_cells(intial_enemy_amount)
		for i in range(intial_enemy_amount):
			var enemy_index = randi() % enemy_prefabs.size()
			var enemy = enemy_prefabs[enemy_index]
			var enemy_inst: Node2D = enemy.instantiate()
			enemy_inst.global_position = tile_map.to_global(tile_map.map_to_local(cells_intial[i]))
			add_child(enemy_inst)
			var enemy_health = enemy_inst.get_node("Health")
			enemy_health.death.connect(_on_enemy_death)
		has_executed_code = true
	var scene_instances = get_tree().get_nodes_in_group("enemy")

	# 获取实例数量
	var instance_count = scene_instances.size()

	# 打印实例数量
	print("enemyScene instances: ", instance_count)

