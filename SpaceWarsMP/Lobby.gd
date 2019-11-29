extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const PORT = 4654
var LOBBY_ITEMS = []

# Called when the node enters the scene tree for the first time.
func _ready():
	LOBBY_ITEMS = [ $Label, $Label2, $IDDisplay, $IPInput, $ConnectButton, $NameInput ]
# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_connected_to_host")
# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_disconnected_from_host") 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	var ip_addr = $IPInput.text
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip_addr, PORT)
	get_tree().set_network_peer(peer)


remote func _start_game():
#	for item in LOBBY_ITEMS:
#		item.set_visible(false)
	$ConnectButton.text = "Game Starting Soon!"
	get_parent().switch_3d()

remote func _update_players(ids):
	print("updating players")
	var text_to_show = ""
	var id_list = ids.keys()
	for id in id_list:
		text_to_show += String(id) + " : " + String(ids[id]) + "\n"
	$IDDisplay.text = text_to_show

func _connected_to_host():
	$ConnectButton.text = "Connection Established"
	$ConnectButton.set_disabled(true)
	rpc_id(1, "_update_names", get_tree().get_network_unique_id(), $NameInput.text)

func _disconnected_from_host():
	$ConnectButton.text = "Connect"
	$ConnectButton.set_disabled(false)
	for item in LOBBY_ITEMS:
		item.set_visible(true)

