extends Control

@export var health : Health
var value 

func _ready():
	health.healthchanged.connect(_update)
	_update()
	
func _update():
	value = health.health * 100 / health.max_health
