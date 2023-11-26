extends Camera2D


@export var player: hero
@export var lerp_speed: float = 10


func _ready():
	call_deferred("reparent", get_parent().get_parent())


func _process(delta):
	if player != null:
		global_position = lerp(self.global_position, player.global_position, clampf(lerp_speed * delta, 0, 1))
