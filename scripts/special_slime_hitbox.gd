extends Area2D

var PLAYERBULLET1 : int

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D):
	# 检查碰撞体是否有指定方法
	if body.has_method("_on_hitbox_hit"):
		# 获取孙子节点DroppedBullet
		var player_bullet_dropper = body.get_node("PlayerBulletDropper")
		# 检查孙子节点是否存在且具有 item_type 变量
		if player_bullet_dropper != null:
			# 获取 item_type 变量的值
			var dropped_bullet = player_bullet_dropper.get_node("DroppedBullet")
			if dropped_bullet != null:
				var item_type_value = dropped_bullet.get("item_type")
			# 检查 item_type 是否为 PLAYERBULLET1
				if item_type_value == PLAYERBULLET1:
				# 执行你的逻辑
					body._on_hitbox_hit(get_parent())




