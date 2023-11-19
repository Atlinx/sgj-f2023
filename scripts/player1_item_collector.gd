extends Node2D


@export var player: Player_1
@export var collector_area: Area2D


func _ready():
	collector_area.area_entered.connect(_on_collector_area_entered)


func _on_collector_area_entered(area: Area2D):
	if area.is_in_group("dropped_item"):
		var dropped_item :DroppedItem = area
		if dropped_item.item_type == DroppedItem.ItemType.PlAYERBULLET1:
			player.has_shot = true
			dropped_item.collect()
