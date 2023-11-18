extends Area2D
class_name DroppedItem


signal collected


enum ItemType {
	PlAYERBULLET1,
	PLAYERBULLET2,
}


@export var collision_shape: CollisionShape2D
@export var enabled: bool = false:
	set(value):
		enabled = value
		call_deferred("_update_enabled", enabled)
	get:
		return enabled
@export var item_type: ItemType


func _update_enabled(value):
	visible = enabled
	collision_shape.disabled = not enabled


func _ready():
	_update_enabled(enabled)


func collect():
	collected.emit()
	queue_free()
