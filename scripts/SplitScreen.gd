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

func _on_player_1_death():
	players["1"].camera.enabled = false

func _on_player_1_revive():
	players["1"].camera.enabled = true

func _on_player_2_death():
	players["2"].camera.enabled = false

func _on_player_2_revive():
	players["2"].camera.enabled = true
