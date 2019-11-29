extends Camera

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		translate( Vector3 ( 1, 0, 0) * delta * speed)
	if Input.is_action_pressed("move_left"):
		translate( Vector3 ( -1, 0, 0) * delta * speed)
	if Input.is_action_pressed("move_down"):
		translate( Vector3 ( 0, -1, 0) * delta * speed)
	if Input.is_action_pressed("move_up"):
		translate( Vector3 ( 0, 1, 0) * delta * speed)
	if Input.is_action_pressed("move_forward"):
		translate( Vector3 ( 0, 0, -1) * delta * speed)
	if Input.is_action_pressed("move_back"):
		translate( Vector3 ( 0, 0, 1) * delta * speed)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
