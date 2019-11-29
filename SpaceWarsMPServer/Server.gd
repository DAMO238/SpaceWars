extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const PORT = 4654
const MAX_PLAYERS = 1

var ids = []
var ids_index = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_peer_connected")
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")


func _peer_connected(id):
	ids.append(id)
	print("Player has connected with assigned id: " + String(id))
	if len(ids) == MAX_PLAYERS:
		_start_game()

func _peer_disconnected(id):
	ids.erase(id)
	print("Player has disconnected with assigned id: " + String(id))
	if ids_index.has(id):
		ids_index.erase(id)
	if len(ids) == 0:
		get_tree().set_refuse_new_network_connections(false)

remote func _update_names(id, name):
	ids_index[id] = name
	print("updating names")
	rpc("_update_players", ids_index)

func _start_game():
	get_tree().set_refuse_new_network_connections(true)
	rpc("_start_game")
	$"../Map_3d".ids = ids
	$Start_Timer.start( 10 )

#Use rpc_id(1, "_function_to_run", args) to run commands on server only!

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

