extends Node2D


@export var enemy_prefabs: Array[PackedScene]
@export var enemy_amount = Vector2i(1, 5)
@export var spawn_interval = Vector2i(3, 5)

var _spawn_timer: float = 0

func _process(delta):
	if _spawn_timer <= 0:
		_spawn_timer = randf_range(spawn_interval.x, spawn_interval.y)
		var enemy_count = randi_range(enemy_amount.x, enemy_amount.y)
		for i in enemy_count:
			var enemy_index = randi() % enemy_prefabs.size()
			var enemy = enemy_prefabs[enemy_index]
			var enemy_inst: Node2D = enemy.instantiate()
			add_child(enemy_inst)
			enemy_inst.global_position = global_position
	else:
		_spawn_timer -= delta
