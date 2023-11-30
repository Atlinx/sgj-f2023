extends Node
class_name Health


var time_since_last_self_heal : float = 0
@export var self_heal_interval : float = 0
@export var self_heal : int = 0




signal revive
signal death()
signal damaged(amount: int)
signal healed(amount: int)
signal healthchanged

@export var health: int = 1
@export var max_health: int = 1


func _ready():
	health = max_health

func _process(delta):

	if health > 0:
		if time_since_last_self_heal >= self_heal_interval:
			heal(self_heal)
			time_since_last_self_heal = 0
		else:
			time_since_last_self_heal += delta

func damage(amount: int):
	health -= amount
	damaged.emit(amount)
	healthchanged.emit()
	if health <= 0:
		if get_parent().is_in_group("player"):
			get_parent().global_position = Vector2(10000,10000)
		else:
			get_parent().queue_free()
		death.emit()

func heal(amount: int):
	health += amount
	healed.emit(amount)
	if health > max_health:
		health = max_health
	healthchanged.emit()

func reset_health():
	health = max_health
	healthchanged.emit()
	revive.emit()
