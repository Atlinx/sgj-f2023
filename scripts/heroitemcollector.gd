extends Node2D


@export var health : Health
@export var player: CharacterBody2D
@export var collector_area: Area2D

func _ready():
	collector_area.area_entered.connect(_on_collector_area_entered)


func _on_collector_area_entered(area: Area2D):
	if area.is_in_group("dropped_item"):
		var dropped_item :DroppedItem = area
		if dropped_item.item_type == DroppedItem.ItemType.PLAYERBULLET1:
			player.has_teammate_bullet = true
			dropped_item.collect()
		if dropped_item.item_type == DroppedItem.ItemType.HEART:
			health.heal(5)
			dropped_item.collect()
