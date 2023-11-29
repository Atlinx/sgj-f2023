extends CharacterBody2D
class_name hero

@export var health: Health 
@export var self_heal_interval : float = 0
@export var self_heal : int = 0
@export var fire_sound : AudioStreamPlayer
@export var teammate_bullet_prefab: PackedScene
@export var speed: float = 300.0
@export var player_animation_tree: AnimationTree
@export var has_teammate_bullet_color : ColorRect
@export var sword : PackedScene
@export var fire_interval = 0
@export var cd_color : ColorRect

var fire_timer = 0
var sword_instance
@export var rotation_speed: float = 360.0 # 旋转速度（每秒度数）
@export var total_rotation: float = 360.0 # 总旋转角度

var has_teammate_bullet : bool = false
var in_hand : String = "my_bullet"
var time_since_last_self_heal : float = 0

func _ready():
	has_teammate_bullet_color.hide()
	cd_color.hide()


func _process(delta):

	if fire_timer > 0:
		cd_color.hide()
		fire_timer -= delta
	else:
		cd_color.show()


	if Input.is_action_just_pressed("p2_fire"):
		if has_teammate_bullet:
			fire()
		elif fire_timer <= 0:
			fire_timer = fire_interval
			sword_instance = sword.instantiate()
			add_child(sword_instance)
			await get_tree().create_timer(0.5).timeout
			sword_instance.queue_free()

	
	if has_teammate_bullet:
		has_teammate_bullet_color.show()
		
	if time_since_last_self_heal >= self_heal_interval:
		health.health += self_heal
		time_since_last_self_heal = 0
	else:
		time_since_last_self_heal += delta

func fire():
	var teammate_bullet_inst: PlayerBullet = teammate_bullet_prefab.instantiate()
	get_tree().get_first_node_in_group("level").add_child(teammate_bullet_inst)
	var traget_position = get_tree().get_first_node_in_group("shooter").global_position
	var direction = ( traget_position - global_position).normalized()
	teammate_bullet_inst.construct(self, global_position, direction)
	has_teammate_bullet = false
	has_teammate_bullet_color.hide()
	fire_sound.play()


func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("p2_left", "p2_right", "p2_up", "p2_down")
	velocity = direction * speed

	player_animation_tree.walking = direction != Vector2.ZERO

	move_and_slide()
