extends Node2D


@export var player: Player_2
@export var collector_area: Area2D


func _ready():
	collector_area.area_entered.connect(_on_collector_area_entered)


func _on_collector_area_entered(area: Area2D):
	print("Collector area entered!")
	if area.is_in_group("dropped_item"):
		var dropped_item: DroppedItem = area
		print("Dropped item type:", dropped_item.item_type)
		if dropped_item.item_type == DroppedItem.ItemType.PLAYERBULLET2:
			print("Setting player.has_shot to true")
			player.has_shot = true
		dropped_item.collect()
