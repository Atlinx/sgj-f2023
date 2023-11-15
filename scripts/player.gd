extends CharacterBody2D
class_name Player


@export var bullet_prefab: PackedScene
@export var speed: float = 300.0
@export var has_shot: bool = true


func _process(delta):
	if has_shot and Input.is_action_pressed("p1_fire"):
		var bullet_inst: Bullet = bullet_prefab.instantiate()
		get_parent().add_child(bullet_inst)
		var direction = (get_global_mouse_position() - global_position).normalized()
		bullet_inst.construct(self, global_position, direction)
		has_shot = false


func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")
	velocity = direction * speed

	move_and_slide()
