extends Node2D


@export var bullet: PlayerBullet
@export var item: DroppedItem


func _ready():
	item.visible = false
	bullet.death.connect(_on_bullet_death)


func _on_bullet_death():
	if bullet.damaged_entity:
		if bullet.entity_owner.is_in_group("player"):
			bullet.entity_owner.has_shot = true
		else: print("had free")
	else:
		var grand_parent = get_parent().get_parent()
		item.call_deferred("reparent",grand_parent)
		item.enabled = true
