extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ids = ''
var player_resource = preload("res://Player.tscn")
var players = {}
var running = false
var game_started = false
# Called when the node enters the scene tree for the first time.
func _process(delta):
	var ready = true
	for player in players.values():
		if len(player.plan) == 0:
			ready = false
	if ready and not running and game_started:
		running = true
		_execute_plans()
		for player in players.values():
			player.plan = []


func _execute_plans():
	print("executing plans...")
	for player_id in players.keys():
		players[player_id].current_time = 0
	$Turn_Timer.start( 5.5 )
		#Send plan data to everyone
		#Send final position data for next turn
		#Clear server plan data

func _on_plan_execution_complete():
	print("plans have been executed")
	running = false
	var data = {}
	for player_id in players.keys():
		data[player_id] = [[ players[player_id].plan ], players[player_id].last_frame_positions]
	rpc( "get_plans", data)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_start_timer_complete():
	print("sending player data")
	for id in ids:
		var location = Vector3( rand_range( -100, 100), rand_range( -100, 100), rand_range( -100, 100) )
		var rotation = Vector3( rand_range ( -180, 180 ), rand_range ( -180, 180 ), rand_range ( -180, 180 ) )
		#rpc( "place_player", Vector3( rand_range( -100, 100), rand_range( -100, 100), rand_range( -100, 100) ), Vector3( rand_range ( -180, 180 ), rand_range ( -180, 180 ), rand_range ( -180, 180 ) ), id )
		rpc( "place_player", location, rotation, id)
		_server_place_player( location, rotation, id)
	game_started = true

func _server_place_player( location, rotation, id ):
	players[id] = player_resource.instance()
	add_child(players[id])

