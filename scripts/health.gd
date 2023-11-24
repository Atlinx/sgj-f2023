extends Node
class_name Health


signal death
signal damaged(amount: int)
signal healed(amount: int)
signal healthchanged


@export var health: int = 1
@export var max_health: int = 1


func _ready():
	health = max_health



func damage(amount: int):
	health -= amount
	damaged.emit(amount)
	healthchanged.emit()
	if health <= 0:
		death.emit()
		get_parent().queue_free()


func heal(amount: int):
	health += amount
	healed.emit(amount)
	healthchanged.emit()
	if health > max_health:
		health = max_health
