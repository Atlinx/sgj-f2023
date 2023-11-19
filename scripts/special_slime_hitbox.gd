extends Area2D

@export var bullet: DroppedItem.ItemType

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	# 检查碰撞体是否有指定方法和 item_type 是否为 PLAYERBULLET1
	if body.has_method("_on_hitbox_hit"):
		body._on_hitbox_hit(get_parent())

