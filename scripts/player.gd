extends CharacterBody2D
class_name Shooter

@export var health: Health
@export var self_heal_interval : float = 0
@export var self_heal : int = 0
@export var fire_sound : AudioStreamPlayer
@export var my_bullet_prefab: PackedScene
@export var speed: float = 300.0
@export var has_shot: bool = true
@export var player_animation_tree: AnimationTree
@export var has_my_shot_color : ColorRect
@export var item_collector : Node2D


var has_teammate_bullet : bool = false
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
		fire()


func fire():
	var my_bullet_inst: PlayerBullet = my_bullet_prefab.instantiate()
	get_tree().get_first_node_in_group("level").add_child(my_bullet_inst)
	var mouse_position = get_global_mouse_position()
	var player_to_mouse = (mouse_position - global_position).normalized()
	var spawn_offset = player_to_mouse * 2  # 根据需要调整偏移距离
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

