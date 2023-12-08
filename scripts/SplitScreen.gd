extends Control


@onready var players := { 
	"1" :{
		viewport = $GridContainer/SubViewportContainer/Player1Viewport,
		camera =$GridContainer/SubViewportContainer/Player1Viewport/Camera2D,
		player =  get_tree().get_first_node_in_group("player1")



	},
	"2" : { 
		viewport = $GridContainer/SubViewportContainer2/Player2Viewport,
		camera =$GridContainer/SubViewportContainer2/Player2Viewport/Camera2D,
		player = get_tree().get_first_node_in_group("player2")

	}
}

func _ready():
	players["2"].viewport.world_2d = players["1"].viewport.world_2d
	for node in players.values():
		var remote_transform : = RemoteTransform2D.new()
		remote_transform.remote_path = node.camera.get_path()
		node.player.add_child(remote_transform)
	players["1"].player.get_node("Health").death.connect(_on_player_1_death)
	players["1"].player.get_node("Health").revive.connect(_on_player_1_revive)
	players["2"].player.get_node("Health").death.connect(_on_player_2_death)
	players["2"].player.get_node("Health").revive.connect(_on_player_2_revive)
	get_tree().get_first_node_in_group("game_manager").win.connect(_on_win)


func _on_player_1_death():
	players["1"].camera.enabled = false

func _on_player_1_revive():
	players["1"].camera.enabled = true

func _on_player_2_death():
	players["2"].camera.enabled = false

func _on_player_2_revive():
	players["2"].camera.enabled = true

func _on_win():
	await get_tree().create_timer(5).timeout
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int()+1
	var next_level_path = "res://scenes/level/split_" + str(next_level_number) + ".tscn"
	if ResourceLoader.exists(next_level_path):
		get_tree().change_scene_to_file(next_level_path)
