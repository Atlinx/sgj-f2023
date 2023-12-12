extends CharacterBody2D
class_name hero

@export var dropped_bullet : PackedScene
@export var fire_sound : AudioStreamPlayer
@export var teammate_bullet_prefab: PackedScene
@export var speed: float = 300.0
@export var player_animation_tree: AnimationTree
@export var has_teammate_bullet_color : ColorRect
@export var right_sword : PackedScene
@export var fire_interval = 0.0
@export var cd_color : ColorRect
@export var left_sword : PackedScene
var fire_timer = 0.0
var right_sword_instance
var left_sword_instance
@export var rotation_speed: float = 360.0 # 旋转速度（每秒度数）
@export var total_rotation: float = 360.0 # 总旋转角度
@export var revive_timer : float
signal revive(revive_timer)
signal sword_cd(cd)

var deadth : bool = false
var has_teammate_bullet : int = 0
var time_since_last_self_heal : float = 0
var alive : bool = true


func _process(delta):
	var terrain
	var tile_map = get_tree().get_first_node_in_group("tilemap")
	# 获取单元格的地形数据
	var cell_coords = tile_map.local_to_map(tile_map.to_local(global_position))
	var tile_data = tile_map.get_cell_tile_data(0, cell_coords)
	if tile_data != null:
		terrain = tile_data.terrain
#	if Input.is_action_pressed("change_terrain"):
#		set_collision_mask_value(3,false)
#	else: 
#		set_collision_mask_value(3,true)
		
	if terrain == 4:
		set_collision_layer_value(7,true)
		set_collision_layer_value(6,false)
	if terrain == 1:
		set_collision_layer_value(7,false)
		set_collision_layer_value(6,true)

	if alive == false:
		return

	if has_teammate_bullet > 0:
		has_teammate_bullet_color.show()
	else:
		has_teammate_bullet_color.hide()

	if fire_timer > 0:
		cd_color.hide()
		fire_timer -= delta
	else:
		cd_color.show()

	if Input.is_action_just_pressed("pass_bullet"):
		if has_teammate_bullet:
			fire()


	if Input.is_action_just_pressed("p2_right_fire"):
		if fire_timer <= 0:
			fire_timer = fire_interval
			sword_cd.emit(fire_interval)
			right_sword_instance = right_sword.instantiate()
			add_child(right_sword_instance)
			await get_tree().create_timer(0.2).timeout
			if right_sword_instance != null:
				right_sword_instance.queue_free()

	if Input.is_action_just_pressed("p2_left_fire"): 
		if fire_timer <= 0:
			fire_timer = fire_interval
			sword_cd.emit(fire_interval)
			left_sword_instance = left_sword.instantiate()
			add_child(left_sword_instance)
			await get_tree().create_timer(0.2).timeout
			if left_sword_instance != null:
				left_sword_instance.queue_free()




	if has_teammate_bullet:
		has_teammate_bullet_color.show()
		


func fire():
	var teammate_bullet_inst: PlayerBullet = teammate_bullet_prefab.instantiate()
	get_tree().get_first_node_in_group("level").add_child(teammate_bullet_inst)
	var traget_position = get_tree().get_first_node_in_group("shooter").global_position
	var direction = ( traget_position - global_position).normalized()
	teammate_bullet_inst.construct(self, global_position, direction)
	has_teammate_bullet -= 1
	has_teammate_bullet_color.hide()
	fire_sound.play()


func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("p2_left", "p2_right", "p2_up", "p2_down")
	velocity = direction * speed

	player_animation_tree.walking = direction != Vector2.ZERO

	move_and_slide()



func _deferred_bullet_addition(bullet_instance, death_position):
	bullet_instance.global_position = death_position
	bullet_instance.enabled = true
	var level = get_tree().get_first_node_in_group("level")
	level.add_child(bullet_instance)

#应该改成有几个掉落几个
func _on_health_death_position(death_position):
	if has_teammate_bullet > 0:
		for amount in range(has_teammate_bullet):
			var bullet_instance = dropped_bullet.instantiate()
			call_deferred("_deferred_bullet_addition", bullet_instance, death_position)
		has_teammate_bullet = 0
	alive = false
	revive.emit(revive_timer)
	await get_tree().create_timer(revive_timer).timeout
	alive = true

