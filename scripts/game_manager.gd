extends Node


var players = {}
@export var score: int = 0
@export var score_label: Label


#func _ready():
#	on_score_update()
#
#
#func on_enemy_death():
#	score += 1
#	on_score_update()
#
#
#func on_score_update():
#
#	score_label.text = "SCORE: %s" % score

func _process(delta):
	if Input.is_key_pressed(KEY_BACKSPACE):
		get_tree().reload_current_scene()
