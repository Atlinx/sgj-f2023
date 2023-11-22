extends CharacterBody2D
class_name Player



@export var fire_sound : AudioStreamPlayer
@export var my_bullet_prefab: PackedScene
@export var teammate_bullet_prefab: PackedScene
@export var speed: float = 300.0
@export var has_shot: bool = true
@export var player_animation_tree: AnimationTree
@export var initial_position:Vector2 = Vector2(0,0)
var has_teammate_bullet : bool = false
var in_hand : String = "my_bullet"

@rpc("authority","call_local")

func _enter_tree() ->void:
	set_multiplayer_authority(name.to_int())


func _ready():
	position = initial_position

func _process(delta):
	
	if not is_multiplayer_authority():
		return
	
	if Input.is_key_pressed(KEY_1):
		in_hand = "my_bullet"
	if Input.is_key_pressed(KEY_2):
		in_hand = "teammate_bullet"
	
	if has_shot and Input.is_action_just_pressed("p1_fire"):
		if in_hand == "my_bullet":
			var my_bullet_inst: Bullet = my_bullet_prefab.instantiate()
			get_tree().get_root().add_child(my_bullet_inst)
			var direction = (get_global_mouse_position() - global_position).normalized()
			my_bullet_inst.construct(self, global_position, direction)
			has_shot = false
			fire_sound.play()
	if has_teammate_bullet and Input.is_action_just_pressed("p1_fire"):
		if in_hand == "teammate_bullet":
			var teammate_bullet_inst: Bullet = teammate_bullet_prefab.instantiate()
			get_tree().get_root().add_child(teammate_bullet_inst)
			var direction = (get_global_mouse_position() - global_position).normalized()
			teammate_bullet_inst.construct(self, global_position, direction)
			has_teammate_bullet = false
			fire_sound.play()



func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")
	velocity = direction * speed

	player_animation_tree.walking = direction != Vector2.ZERO

	move_and_slide()
