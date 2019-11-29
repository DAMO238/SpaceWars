extends RigidBody

var current_time = 90
var current_plan_time = 5
var plan = []
var engine_plan = []
var last_frame_positions = []

# Called when the node enters the scene tree for the first time.
func _ready():
	set_last_frame_positions()

remote func get_plan(_plan):
	plan = _plan
	engine_plan = plan[0]

func set_last_frame_positions():
	last_frame_positions.clear()
	last_frame_positions.append( get_translation() )
	last_frame_positions.append( get_rotation() )
	last_frame_positions.append( get_linear_velocity() )
	last_frame_positions.append( get_angular_velocity() )

func _physics_process(delta):
	if typeof(engine_plan) == TYPE_ARRAY:
		return
	if len(engine_plan.elements) == 0:
		return
	if current_time > current_plan_time:
		set_translation( last_frame_positions[0] )
		set_rotation( last_frame_positions[1] )
		set_linear_velocity( last_frame_positions[2] )
		set_angular_velocity( last_frame_positions[3] )
		set_last_frame_positions()
		return
	var current_element = ''
	var running_total = 0
	for element in engine_plan.elements:
		running_total += element.time
		current_element = element  # This element either has finished or needs to be done now
		if current_time <= running_total:  # Have we gone too far?
			break
	add_central_force( self.transform.basis.xform(current_element.thrust_direction) * current_element.thrust_percentage / 100)
	add_torque( self.transform.basis.xform(current_element.rot_axis) * current_element.rot_percentage / 100)
	current_time += delta
	set_last_frame_positions()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
