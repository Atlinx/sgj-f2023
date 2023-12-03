extends CharacterBody2D
class_name Shooter

signal revive(revive_timer)
@export var fire_sound : AudioStreamPlayer
@export var my_bullet_prefab: PackedScene
@export var speed: float = 300.0
@export var has_shot: bool = true
@export var player_animation_tree: AnimationTree
@export var has_my_shot_color : ColorRect
@export var item_collector : Node2D
@export var revive_timer : float
var alive : bool = true
var has_teammate_bullet : bool = false



func _process(delta):
	if alive == false:
		return


	if has_shot:
		has_my_shot_color.show()
	if has_shot and Input.is_action_just_pressed("p1_fire"):
		fire()


func fire():
	var my_bullet_inst: PlayerBullet = my_bullet_prefab.instantiate()
	get_tree().get_first_node_in_group("level").add_child(my_bullet_inst)
	var mouse_position = get_global_mouse_position()
	var player_to_mouse = (mouse_position - global_position).normalized()
	var spawn_offset = player_to_mouse * 5  # 根据需要调整偏移距离
	var initial_position = global_position + spawn_offset
	my_bullet_inst.construct(self, initial_position, player_to_mouse)
	has_shot = false
	has_my_shot_color.hide()
	fire_sound.play()


func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")
	velocity = direction * speed

	player_animation_tree.walking = direction != Vector2.ZERO

	move_and_slide()

func _deferred_bullet_addition(bullet_instance, death_position):
	bullet_instance.global_position = death_position
	bullet_instance.enabled = true
	var level = get_tree().get_first_node_in_group("level")
	level.add_child(bullet_instance)


func _on_health_death_position(death_position):
	alive = false
	revive.emit(revive_timer)
	await get_tree().create_timer(revive_timer).timeout
	alive = true


func _on_hitbox_area_entered(area):
	var last_portal_index = 0
	var can_teleport = true
	for i in range(1, 9):
		var portal_group_name = "portal" + str(i)
		if area.is_in_group(portal_group_name):
			print(portal_group_name)
			var target_portal_group_name = "portal" + str((i % 8) + 1)
			
			# 检查当前传送门是否与上一个传送门相邻
			if abs(i - last_portal_index) == 1 or abs(i - last_portal_index) == 7:
				if can_teleport:
					var target_portal = get_tree().get_first_node_in_group(target_portal_group_name)
					if target_portal:
						global_position = target_portal.global_position
						print("Teleporting to", target_portal_group_name, "at position:", global_position)
						
						# 记录当前传送门索引
						last_portal_index = i
						# 设置 can_teleport 为 false，以防止在短时间内多次触发传送
						can_teleport = false
						# 启动一个计时器，一段时间后将 can_teleport 重新设置为 true
						$FlashTimer.start()
						break
