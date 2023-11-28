extends Area2D

var PLAYERBULLET1 : int

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D):
	# 检查碰撞体是否有指定方法
	if body.has_method("_on_hitbox_hit"):
		body._on_hitbox_hit(get_parent())




