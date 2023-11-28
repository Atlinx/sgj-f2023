extends Control


@onready var players := { 
	"1" :{
		viewport = $GridContainer/SubViewportContainer/Player1Viewport,
		camera =$GridContainer/SubViewportContainer/Player1Viewport/Camera2D,
		player =  $GridContainer/SubViewportContainer/Player1Viewport/Level1/World/Level/Shooter



	},
	"2" : { 
		viewport = $GridContainer/SubViewportContainer2/Player2Viewport,
		camera =$GridContainer/SubViewportContainer2/Player2Viewport/Camera2D,
		player =$GridContainer/SubViewportContainer/Player1Viewport/Level1/World/Level/Hero

	}
}

func _ready():
	players["2"].viewport.world_2d = players["1"].viewport.world_2d
	for node in players.values():
		var remote_transform : = RemoteTransform2D.new()
		remote_transform.remote_path = node.camera.get_path()
		node.player.add_child(remote_transform)
