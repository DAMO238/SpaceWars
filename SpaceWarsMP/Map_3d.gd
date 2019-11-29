extends Node


var player_resource = preload("res://Player.tscn")
var local_player = ''
var remote_players = {}




#remote func place_local_player(position, rotation):
#	local_player = player_resource.new()
#	local_player.set_rotation(rotation)
#	local_player.set_translation(position)
#	local_player.owner_id = get_tree().get_network_unique_id()
	
remote func place_player(position, rotation, id):
	
	
	if id == get_tree().get_network_unique_id():
		print("got local player")
		local_player = player_resource.instance()
		local_player.set_rotation(rotation)
		local_player.set_translation(position)
		local_player.owner_id = id
		local_player.start_positions.append([position, rotation, local_player.get_linear_velocity(), local_player.get_angular_velocity()])
		add_child(local_player)
	else:
		print("got a player")
		remote_players[id] = player_resource.instance()
		remote_players[id].set_rotation(rotation)
		remote_players[id].set_translation(position)
		remote_players[id].owner_id = id
		add_child(remote_players[id])
		# Disable the ui of remote player
		var children = remote_players[id].get_children()
		for child in children:
			if 'Panel' in child.name:
				child.free()
		

remote func get_plans(data):
	# data is of the form of a dictionary with keys as the ids and the values being an array with the plans
	# (as an array in of itself) and final positions
	for id in data.keys():
		if id == get_tree().get_network_unique_id():
			print("got local player plan")
			local_player.finish_turn(data[id][1])
		else:
			print("got remote player plan")
			remote_players[id].finish_turn(data[id][1], data[id][0])

