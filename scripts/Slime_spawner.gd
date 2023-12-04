extends Node

@export var sneak_slime: Array[PackedScene]
@export var enemy_prefabs: Array[PackedScene]
@export var enemy_amount = Vector2i(1, 5)
@export var spawn_interval = Vector2i(3, 5)
@export var sneak_amount = Vector2i(1, 5)
@export var sneak_interval = Vector2i(3, 5)
@export var tile_map: TileMap
@export var game_manager: GameManager
@export var start_spawn_delay: float = 5
@export var sneak_radius : float
@export var imposible_sneak_time : float
var _spawn_timer: float = 0
var _spawnable_cells: Array[Vector2i] = []
const WATER_LAYER : int = 2
const WALL_TERRAIN_ID: int = 0
var spawnable_id :int = -1
var _sneak_timer: float = 0


func _ready():
	_sneak_timer = imposible_sneak_time
	for cell in tile_map.get_used_cells(0):
		var tile_data = tile_map.get_cell_tile_data(0, cell)
		if tile_data.terrain == spawnable_id:
			_spawnable_cells.append(cell)
	set_process(false)
	await get_tree().create_timer(start_spawn_delay).timeout
	set_process(true)


func _get_random_cells(amount: int) -> Array[Vector2i]:
	var temp_spawnable_cells = _spawnable_cells.duplicate() 
	var valid_cells: Array[Vector2i] = []
	for i in amount:
		var valid_cell_index = randi() % temp_spawnable_cells.size()
		valid_cells.append(temp_spawnable_cells[valid_cell_index])
		temp_spawnable_cells.remove_at(valid_cell_index)
	return valid_cells


func _process(delta):

	if _spawn_timer <= 0:
		_spawn_timer = randf_range(spawn_interval.x, spawn_interval.y)
		var enemy_count = randi_range(enemy_amount.x, enemy_amount.y)

	# normal slime
		var random_cells_normal = _get_random_cells(enemy_count)
		for i in range(enemy_count):
			var enemy_index = randi() % enemy_prefabs.size()
			var enemy = enemy_prefabs[enemy_index]
			var enemy_inst: Node2D = enemy.instantiate()
			enemy_inst.global_position = tile_map.to_global(tile_map.map_to_local(random_cells_normal[i]))
			add_child(enemy_inst)
			var enemy_health = enemy_inst.get_node("Health")
			enemy_health.death.connect(_on_enemy_death)

	else:
		_spawn_timer -= delta

	if _sneak_timer <= 0:
		_sneak_timer = randf_range(sneak_interval.x, sneak_interval.y)
		var enemy_count = randi_range(sneak_amount.x, sneak_amount.y)

	# normal slime
		var random_cells_normal = _get_random_cells(enemy_count)
		for i in range(enemy_count):
			var enemy_index = randi() % sneak_slime.size()
			var enemy = sneak_slime[enemy_index]
			var enemy_inst: Node2D = enemy.instantiate()
			var spawn_position = get_nearby_player_position()
			enemy_inst.global_position = tile_map.to_global(tile_map.map_to_local(spawn_position))
			add_child(enemy_inst)
			var enemy_health = enemy_inst.get_node("Health")
			enemy_health.death.connect(_on_enemy_death)

	else:
		_sneak_timer -= delta

func _on_enemy_death():
	game_manager.on_enemy_death()


func _on_game_manager_win():
	set_process(false)

func get_nearby_player_position():
	var player_position = get_tree().get_first_node_in_group("shooter").global_position
	var angle = randf_range(0, 2 * PI)
	var distance = randf_range(0, sneak_radius)
	var offset = Vector2(cos(angle), sin(angle)) * distance
	print(player_position + offset)
	return player_position + offset
#估计还是要独立出来因为一般来说史莱姆只能生成在-1地形中
