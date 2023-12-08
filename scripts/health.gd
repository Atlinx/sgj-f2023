extends Node
class_name Health


var time_since_last_self_heal : float = 0
@export var self_heal_interval : float = 0
@export var self_heal : int = 0



signal death_position(death_position)
signal revive
signal death
signal damaged(amount: int)
signal healed(amount: int)
signal healthchanged

@export var defense : int = 0
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
	var healh_decrease = amount - defense
	if healh_decrease <= 0:
		healh_decrease = 1
	health -= healh_decrease
	healthchanged.emit()
	if health <= 0:
		death.emit()
		if get_parent().is_in_group("player"):
			death_position.emit(get_parent().global_position)
			get_parent().global_position = Vector2(10000,10000)
		else:
			get_parent().queue_free()


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
