extends Node

@export var special_slime: Array[PackedScene]
@export var enemy_prefabs: Array[PackedScene]
@export var enemy_amount = Vector2i(1, 5)
@export var spawn_interval = Vector2i(3, 5)
@export var tile_map: TileMap
@export var game_manager: GameManager
@export var start_spawn_delay: float = 5
@export var intial_enemy_amount : int = 0

var _spawn_timer: float = 0
var _spawnable_cells: Array[Vector2i] = []

const WALL_TERRAIN_ID: int = 0

func _ready():
	for cell in tile_map.get_used_cells(0):
		var tile_data = tile_map.get_cell_tile_data(0, cell)
		if tile_data.terrain != WALL_TERRAIN_ID:
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
		
	# special slime
#		var random_cells_special = _get_random_cells(enemy_count)
#		for i in range(enemy_count):
#			var special_slime_index = randi() % special_slime.size()
#			var special_slime_enemy = special_slime[special_slime_index]
#			var special_slime_inst: Node2D = special_slime_enemy.instantiate()
#			special_slime_inst.global_position = tile_map.to_global(tile_map.map_to_local(random_cells_special[i]))
#			add_child(special_slime_inst)
#			var special_slime_health = special_slime_inst.get_node("Health")
#			special_slime_health.death.connect(_on_enemy_death)

	else:
		_spawn_timer -= delta


func _on_enemy_death():
	game_manager.on_enemy_death()