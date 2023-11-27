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

var has_teammate_bullet : bool = false
var in_hand : String = "my_bullet"
var time_since_last_self_heal : float = 0

func _ready():
	has_teammate_bullet_color.hide()



func _process(delta):
	
	if has_teammate_bullet  and Input.is_action_just_pressed("p2_fire"):
		fire()
	
	if has_teammate_bullet:
		has_teammate_bullet_color.show()
		
	if time_since_last_self_heal >= self_heal_interval:
		health.health += self_heal
		time_since_last_self_heal = 0
	else:
		time_since_last_self_heal += delta

func fire():
	get_parent().get_node("Shooter").has_shot = true
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
