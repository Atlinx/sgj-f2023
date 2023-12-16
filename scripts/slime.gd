extends CharacterBody2D

@export var ai : Node
@export var debug_speed : float = 64
var on_wall : bool = false  # 用于跟踪是否与墙壁碰撞
var collision_timer : float = 0  # 碰撞计时器
var collision_threshold : float = 2.0  # 碰撞时间阈值
var tile_area

func _ready():
	ai.speed = debug_speed

# 你的代码...

# 修改 _on_area_2d_area_entered 函数
func _on_area_2d_area_entered(area):
	tile_area = area
	if area.is_in_group("highland"):
		on_wall = true  # 将 on_wall 设置为 true，表示进入了墙壁区域
		# 执行你希望在进入区域时进行的逻辑

# 修改 _on_area_2d_area_exited 函数
func _on_area_2d_area_exited(area):
	if area.is_in_group("highland"):
		on_wall = false  # 将 on_wall 设置为 false，表示离开了墙壁区域
		collision_timer = 0  # 重置碰撞计时器

# 修改 _process 函数
func _process(delta):
	if on_wall:
		collision_timer += delta  # 累加碰撞计时器

		if collision_timer >= collision_threshold:
			on_wall = false  # 重置碰撞标志
			collision_timer = 0  # 重置碰撞计时器
			var tile_map = get_tree().get_first_node_in_group("tilemap")
			var tile_position = tile_area.global_position
			var cell_coords = tile_map.local_to_map(tile_map.to_local(tile_position))
			
			# 设置当前单元
			tile_map.set_cell(0, cell_coords, 0, Vector2i(12, 1), 0)
			
			# 设置周围八格
			for x in range(cell_coords.x - 1, cell_coords.x + 2):
				for y in range(cell_coords.y - 1, cell_coords.y + 2):
					var current_cell = Vector2i(x, y)
					var cell_data = tile_map.get_cell_tile_data(0, current_cell)
					if cell_data != null:
						# 设置周围八格的单元
						tile_map.set_cell(0, current_cell, 0, Vector2i(12, 1), 0)
						tile_map.set_cell(1, current_cell, 0, Vector2i(0,12), 0)


