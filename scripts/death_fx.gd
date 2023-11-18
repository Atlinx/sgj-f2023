extends Node2D


@export var fx_nodes: Array[Node]
@export var lifetime: float = 5

var _timer: float = 0
var _dying: bool = false


func _ready():
	set_process(false)


func on_death():
	if _dying:
		return
	_dying = true
	reparent(get_parent().get_parent())
	set_process(true)
	for fx_node in fx_nodes:
		if fx_node is CPUParticles2D:
			fx_node.emitting = true


func _process(delta: float):
	_timer += delta
	if _timer > lifetime:
		queue_free()
