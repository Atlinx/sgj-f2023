extends CharacterBody2D

@export var ai : Node
@export var debug_speed : float = 64
var on_wall : bool = false  # 用于跟踪是否与墙壁碰撞
var collision_timer : float = 0  # 碰撞计时器
var collision_threshold : float = 2.0  # 碰撞时间阈值

func _ready():
	ai.speed = debug_speed



# ... 其他代码 ...

func _physics_process(_delta):
	# ... 其他逻辑 ...

	# 碰撞检测
	var collision = move_and_collide(Vector2.ZERO, true, true)
	
	if collision != null:
		var collider = collision.get_collider()
		if  collider.is_in_group("Wall"):
			print(2)
			on_wall = true
			collision_timer += _delta
		else:
			on_wall = false
			collision_timer = 0

	# ... 其他逻辑 ...

	# 如果在墙壁上摩擦并且碰撞时间超过阈值，将墙壁摧毁
	if on_wall and collision_timer > collision_threshold:
		print(0)
		var tile_map = get_tree().get_first_node_in_group("tilemap")
		var my_position = global_position
		var cell_coords = tile_map.local_to_map(tile_map.to_local(my_position))
		var cell_data = tile_map.get_cell_tile_data(0, cell_coords)
		if cell_data != null:
			print(1)
#			if cell_data.terrain == 1:
			# 设置当前单元
			tile_map.set_cell(0, cell_coords, 0, Vector2i(0, 0), 0)


