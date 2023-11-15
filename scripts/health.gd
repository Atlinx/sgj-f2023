extends Node
class_name Health


signal death
signal damaged(amount: int)
signal healed(amount: int)


@export var health: int = 1
@export var max_health: int = 1


func _ready():
	health = max_health


func damage(amount: int):
	health -= amount
	damaged.emit(amount)
	if health <= 0:
		death.emit()
		get_parent().queue_free()


func heal(amount: int):
	health += amount
	healed.emit(amount)
	if health > max_health:
		health = max_health
