extends Node


@export var sneak_slime: Array[PackedScene] 
@export var sneak_amount = Vector2i(1, 1)
@export var sneak_interval = Vector2i(10, 20)
@export var tile_map: TileMap
@export var game_manager: GameManager
@export var sneak_radius : float = 200
@export var imposible_sneak_time : float = 45
var _spawn_timer: float = 0
var _spawnable_cells: Array[Vector2i] = []
const WATER_LAYER : int = 2
const WALL_TERRAIN_ID: int = 0
var _sneak_timer: float = 0
var shooter

func _ready():
	shooter = get_tree().get_first_node_in_group("shooter")
	set_process(false)
	await get_tree().create_timer(imposible_sneak_time).timeout
	set_process(true)


func _process(delta):


	if _sneak_timer <= 0 and shooter.alive == true:
		_sneak_timer = randf_range(sneak_interval.x, sneak_interval.y)
		var enemy_count = randi_range(sneak_amount.x, sneak_amount.y)

	# normal slime

		for i in range(enemy_count):
			var enemy_index = randi() % sneak_slime.size()
			var enemy = sneak_slime[enemy_index]
			var enemy_inst: Node2D = enemy.instantiate()
			var spawn_position = get_nearby_player_position()
			if spawn_position != Vector2.ZERO:
				enemy_inst.global_position = spawn_position
				var cell_coords = tile_map.local_to_map(spawn_position)
				var tile_data = tile_map.get_cell_tile_data(0, cell_coords)
				add_child(enemy_inst)
				var enemy_health = enemy_inst.get_node("Health")
				enemy_health.death.connect(_on_enemy_death)

	else:
		_sneak_timer -= delta

func _on_enemy_death():
	game_manager.on_enemy_death()


#很容易生成在墙里面，得隔开
func get_nearby_player_position():
	var player_position = get_tree().get_first_node_in_group("shooter").global_position

	# 最大尝试次数，以防找不到有效位置
	var max_attempts = 10
	var attempt = 0

	while attempt < max_attempts:
		var angle = randf_range(0, 2 * PI)
		var distance = randf_range(0, sneak_radius)
		var offset = Vector2(cos(angle), sin(angle)) * distance
		var spawn_position = player_position + offset

		# 将生成位置转换为地图单元格坐标
		var cell_coords = tile_map.local_to_map(tile_map.to_local(spawn_position))

		# 获取单元格的地形数据
		var tile_data = tile_map.get_cell_tile_data(0, cell_coords)
		if tile_data == null:
			return Vector2.ZERO

		# 检查地形是否符合要求
		if tile_data.terrain == 4:
			return spawn_position
		attempt += 1
	return Vector2.ZERO



func _on_game_manager_stop_spawning():
	set_process(false)
