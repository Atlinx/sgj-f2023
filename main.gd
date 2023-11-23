extends Node

@onready var players : Node = $World/Level/Players
const PLAYER = preload("res://scenes/player.tscn")
var peer = ENetMultiplayerPeer.new()


func _on_host_button_down():
	var error = peer.create_server(7788)
	if error != OK:
		printerr("error",error)
		return
	multiplayer.multiplayer_peer = peer
	
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	
	add_player(multiplayer.get_unique_id())
	
func add_player(id:int) -> void:
	var player = PLAYER.instantiate()
	player.name = str(id)
	players.add_child(player)
	
func _on_peer_connected(id:int) -> void:
	print("has player connect, ID:",id)
	add_player(id)
	pass


func _on_join_button_down():
	peer.create_client("127.0.0.1",7788)
	multiplayer.multiplayer_peer = peer

