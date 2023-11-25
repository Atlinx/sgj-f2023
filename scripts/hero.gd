extends CharacterBody2D
class_name hero

@export var health: Health 
@export var self_heal_interval : float = 0
@export var self_heal : int = 0
@export var fire_sound : AudioStreamPlayer
@export var my_bullet_prefab: PackedScene
@export var teammate_bullet_prefab: PackedScene
@export var speed: float = 300.0
@export var has_shot: bool = true
@export var player_animation_tree: AnimationTree
@export var mulitiplayer_synchronizer : MultiplayerSynchronizer
@export var has_teammate_bullet_color : ColorRect

var has_teammate_bullet : bool = false
var in_hand : String = "my_bullet"
var time_since_last_self_heal : float = 0




func _ready():
	mulitiplayer_synchronizer.set_multiplayer_authority(str(name).to_int())



func _process(delta):
	
	if mulitiplayer_synchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		return
	
	if has_teammate_bullet:
		has_teammate_bullet_color.show()
		
	if time_since_last_self_heal >= self_heal_interval:
		health.health += self_heal
		time_since_last_self_heal = 0
		print("111")
	else:
		time_since_last_self_heal += delta




func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")
	velocity = direction * speed

	player_animation_tree.walking = direction != Vector2.ZERO

	move_and_slide()
