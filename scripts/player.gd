extends CharacterBody2D
class_name Shooter

@export var health: Health
@export var self_heal_interval : float = 0
@export var self_heal : int = 0
@export var fire_sound : AudioStreamPlayer
@export var my_bullet_prefab: PackedScene
@export var teammate_bullet_prefab: PackedScene
@export var speed: float = 300.0
@export var has_shot: bool = true
@export var player_animation_tree: AnimationTree
@export var has_my_shot_color : ColorRect


var has_teammate_bullet : bool = false
var in_hand : String = "my_bullet"
var time_since_last_self_heal : float = 0






func _process(delta):

	
	if has_shot:
		has_my_shot_color.show()
		
	if time_since_last_self_heal >= self_heal_interval:
		health.heal(self_heal)
		time_since_last_self_heal = 0
	else:
		time_since_last_self_heal += delta
	
	
	if has_shot and Input.is_action_just_pressed("p1_fire"):
		if in_hand == "my_bullet":
			fire()

	if has_teammate_bullet and Input.is_action_just_pressed("p1_fire"):
		if in_hand == "teammate_bullet":
			var teammate_bullet_inst: PlayerBullet = teammate_bullet_prefab.instantiate()
			get_tree().get_root().add_child(teammate_bullet_inst)
			var direction = (get_global_mouse_position() - global_position).normalized()
			teammate_bullet_inst.construct(self, global_position, direction)
			has_teammate_bullet = false
			fire_sound.play()
			

func fire():
	var my_bullet_inst: PlayerBullet = my_bullet_prefab.instantiate()
	get_tree().get_first_node_in_group("level").add_child(my_bullet_inst)
	var mouse_position = get_global_mouse_position()
	var player_to_mouse = (mouse_position - global_position).normalized()
	var spawn_offset = player_to_mouse * 20  # 根据需要调整偏移距离
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

