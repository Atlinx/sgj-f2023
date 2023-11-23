extends CanvasLayer
#
#
##var player : Player
##var health = 0
##var value 
##
##func _ready():
##	player = get_tree().get_first_node_in_group("player")
##	health = player.get_node("Health")
##	health.healthchanged.connect(_update)
##	_update()
##
##func _update():
##	value = health.health * 100 / health.max_health 
