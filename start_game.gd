extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_single_player_button_down():
	var scene = load("res://scenes/single_player_main.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()


func _on_multiplayer_button_down():
	var scene = load("res://scenes/multiplayer.tscn").instantiate()

	get_tree().root.add_child(scene)
	self.hide()
