extends Node


@export var player_1_viewport : Viewport
@export var player_2_viewport : Viewport


#	score_label.text = "SCORE: %s" % score
func _ready():
	player_1_viewport = player_2_viewport


func _process(_delta):
	if Input.is_key_pressed(KEY_BACKSPACE):
		get_tree().reload_current_scene()

func on_enemy_death():
	pass
