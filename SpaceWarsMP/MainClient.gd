extends Node

#TODO: Set up a way to make a plan from the 3d view and then a way to execute a given plan locally (preview), then send to server for calculating the turn. 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func switch_3d():
	print("scheduled switch to 3d mode")
	$Timer_3d.start( 5 )
	
	


func switch_lobby():
	pass


func clear_scenes():
	for child in get_children():
		if child != $Timer_3d:
			get_tree().queue_delete(child)

func _remove_node(nodes):
	for node in nodes:
		if len(node.get_children()) == 0:
			node.remove_and_skip()
		else:
			_remove_node(node.get_children())


func switching_3d():
	print("switching now")
	$Timer_3d.stop()
	#clear_scenes()
	$Lobby.queue_free()
	var scene_3d = preload("res://Map_3d.tscn")
	var node = scene_3d.instance()
	add_child(node)