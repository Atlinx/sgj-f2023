extends Node2D

signal get_gold
@export var health : Health
@export var player: CharacterBody2D
@export var collector_area: Area2D

func _ready():
	collector_area.area_entered.connect(_on_collector_area_entered)
	collector_area.body_entered.connect(_on_collector_bullet_entered)

func _on_collector_area_entered(area: Area2D):
	if area.is_in_group("dropped_item"):
		var dropped_item :DroppedItem = area
		if dropped_item.item_type == DroppedItem.ItemType.PLAYERBULLET1:
			player.has_shot += 1
			dropped_item.collect()
		elif dropped_item.item_type == DroppedItem.ItemType.HEART:
			get_gold.emit()
			dropped_item.collect()

func _on_collector_bullet_entered(bullet: CharacterBody2D):
	if bullet.is_in_group("PassingBullet"):
			player.has_shot += 1
			get_tree().get_first_node_in_group("PassingBullet").queue_free()


