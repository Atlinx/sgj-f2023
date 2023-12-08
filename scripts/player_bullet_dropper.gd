extends Node2D


@export var bullet: PlayerBullet
@export var item: DroppedItem
var bullet_has_added : bool = false

func _ready():
	item.visible = false
	bullet.death.connect(_on_bullet_death)


func _on_bullet_death():
	if bullet.damaged_entity and bullet_has_added == false:
		if bullet.entity_owner.is_in_group("player"):
			bullet.entity_owner.has_shot += 1
			bullet_has_added = true
		else: print("had free")
	else:
		var grand_parent = get_parent().get_parent()
		item.call_deferred("reparent",grand_parent)
		item.enabled = true
