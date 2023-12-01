extends CharacterBody2D

@export var ai : Node
@export var debug_speed : float = 64


func _ready():
	ai.speed = debug_speed


func _process(delta):
#	get_parent().set_progress(get_parent().get_progress()+ delta* debug_speed)
#	if get_parent().get_progress_ratio() == 1:
#		queue_free()
	pass
