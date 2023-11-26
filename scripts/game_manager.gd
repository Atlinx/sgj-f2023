extends Node
class_name GameManager





func _process(_delta):
	if Input.is_key_pressed(KEY_BACKSPACE):
		get_tree().reload_current_scene()

func on_enemy_death():
	pass
