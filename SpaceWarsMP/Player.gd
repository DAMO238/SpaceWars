extends RigidBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var plan_resource = load("res://Plan.gd")
var thrust_element_resource = load("res://ThrustElement.gd")
var engine_plan = plan_resource.new()
var current_plan_time = 0 #This is for adding to the plan
var engine_plan_index = 0 #This is for running the plan
var current_time = 90 #This is for running the plan
var owner_id = ''

var previous_plans = []

var start_positions = []

var thrust_type = 0 # Thrust type is 0 for linear thrust, and 1 for rotational thrust
var thrust_toggle = null

var xthrust_scroll = null
var ythrust_scroll = null
var zthrust_scroll = null

var xrot_scroll = null
var yrot_scroll = null
var zrot_scroll = null


var time_scroll = null
var play_button = null
var upload_button = null
var new_keyframe_button = null
var delete_keyframe_button = null

# Called when the node enters the scene tree for the first time.
func _ready():
	engine_plan.init(['thrust'])
	thrust_toggle = $EnginePanel/ThrustType
	
	xthrust_scroll = $EnginePanel/XThrust
	ythrust_scroll = $EnginePanel/YThrust
	zthrust_scroll = $EnginePanel/ZThrust
	
	xrot_scroll = $EnginePanel/XRot
	yrot_scroll = $EnginePanel/YRot
	zrot_scroll = $EnginePanel/ZRot
	
	time_scroll = $MainPanel/Time
	play_button = $MainPanel/PlayButton
	upload_button = $MainPanel/UploadButton
	new_keyframe_button = $MainPanel/AddButton
	delete_keyframe_button = $MainPanel/ResetButton
	
	time_scroll.max_value = engine_plan.TURN_TIME



func finish_turn( final_positions, plans = null):
	if plans == null: #And therefore we are the local player...
		start_positions.append( final_positions )
		previous_plans.append( [engine_plan] )
		_on_ResetButton_pressed()
	else:
		start_positions.append( final_positions )
		previous_plans.append( plans )
		_on_ResetButton_pressed()

# TODO: Make start_positions also include velocities!
# TODO: CHECK: Allow a thrust plan to be made from Thrust Elements (Only plan available in this version)
# TODO: Make visual representation of Thrust Element

func _on_AddButton_pressed():
	var action_time = time_scroll.value - current_plan_time
	if action_time <= 0:
		return false
	var thrust_element = thrust_element_resource.new()
	thrust_element.init()
	thrust_element.thrust_direction = Vector3( xthrust_scroll.value, ythrust_scroll.value, zthrust_scroll.value).normalized()
	thrust_element.thrust_percentage = Vector3( xthrust_scroll.value, ythrust_scroll.value, zthrust_scroll.value).length()
	thrust_element.rot_axis = Vector3( xrot_scroll.value, yrot_scroll.value, zrot_scroll.value).normalized()
	thrust_element.rot_percentage = Vector3( xrot_scroll.value, yrot_scroll.value, zrot_scroll.value).length()
	thrust_element.update_torque()
	thrust_element.time = action_time
	engine_plan.add_element(thrust_element)
	current_plan_time += action_time


func _on_ThrustType_toggled(button_pressed):
	thrust_type = button_pressed
	
	xthrust_scroll.editable = !thrust_type
	ythrust_scroll.editable = !thrust_type
	zthrust_scroll.editable = !thrust_type
	
	xrot_scroll.editable = thrust_type
	yrot_scroll.editable = thrust_type
	zrot_scroll.editable = thrust_type
	
	xthrust_scroll.value = 0
	ythrust_scroll.value = 0
	zthrust_scroll.value = 0
	xrot_scroll.value = 0
	yrot_scroll.value = 0
	zrot_scroll.value = 0


func _on_Time_changed(value):
	if time_scroll.value < current_plan_time:
		time_scroll.value = current_plan_time

func _on_ZRot_changed(value):
	if sqrt( pow(xrot_scroll.value, 2) + pow(yrot_scroll.value, 2) + pow(zrot_scroll.value, 2)) > 100:
		zrot_scroll.value = pow(-1, sign(zrot_scroll.value) / 2 - 0.5) * sqrt( 10000 - pow(xrot_scroll.value, 2) - pow(yrot_scroll.value, 2))


func _on_YRot_changed(value):
	if sqrt( pow(xrot_scroll.value, 2) + pow(yrot_scroll.value, 2) + pow(zrot_scroll.value, 2)) > 100:
		yrot_scroll.value = pow(-1, sign(yrot_scroll.value) / 2 - 0.5) * sqrt( 10000 - pow(zrot_scroll.value, 2) - pow(xrot_scroll.value, 2))


func _on_XRot_changed(value):
	if sqrt( pow(xrot_scroll.value, 2) + pow(yrot_scroll.value, 2) + pow(zrot_scroll.value, 2)) > 100:
		xrot_scroll.value = pow(-1, sign(xrot_scroll.value) / 2 - 0.5) * sqrt( 10000 - pow(zrot_scroll.value, 2) - pow(yrot_scroll.value, 2))


func _on_ZThrust_changed(value):
	if sqrt( pow(xthrust_scroll.value, 2) + pow(ythrust_scroll.value, 2) + pow(zthrust_scroll.value, 2)) > 100:
		zthrust_scroll.value = pow(-1, sign(zthrust_scroll.value) / 2 - 0.5) * sqrt( 10000 - pow(xthrust_scroll.value, 2) - pow(ythrust_scroll.value, 2))


func _on_YThrust_changed(value):
	if sqrt( pow(xthrust_scroll.value, 2) + pow(ythrust_scroll.value, 2) + pow(zthrust_scroll.value, 2)) > 100:
		ythrust_scroll.value = pow(-1, sign(ythrust_scroll.value) / 2 - 0.5) * sqrt( 10000 - pow(zthrust_scroll.value, 2) - pow(xthrust_scroll.value, 2))


func _on_XThrust_changed(value):
	if sqrt( pow(xthrust_scroll.value, 2) + pow(ythrust_scroll.value, 2) + pow(zthrust_scroll.value, 2)) > 100:
		xthrust_scroll.value = pow(-1, sign(xthrust_scroll.value) / 2 - 0.5) * sqrt( 10000 - pow(zthrust_scroll.value, 2) - pow(ythrust_scroll.value, 2))


func _on_PlayButton_pressed():
	# Debug
	print("Engine Plan: ")
	for element in engine_plan.elements:
		print("{type} for {time} seconds with {thrust_direction} * {thrust_percentage} thrust and {rot_axis} * {rot_percentage}!".format({"type" : element.type, "time" : element.time, "thrust_direction" : element.thrust_direction, "thrust_percentage" : element.thrust_percentage, "rot_axis" : element.rot_axis, "rot_percentage" : element.rot_percentage }))
	# Debug End
	current_time = 0

func _physics_process(delta):
	if len(engine_plan.elements) == 0:
		return
	if current_time > current_plan_time:
		set_translation( start_positions.back()[0] )
		set_rotation( start_positions.back()[1] )
		set_linear_velocity( start_positions.back()[2] )
		set_angular_velocity( start_positions.back()[3] )
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



func _on_BackButton_pressed():
	current_plan_time -= engine_plan.elements.back().time
	engine_plan.remove_last_element()


func _on_ResetButton_pressed():
	current_plan_time = 0
	engine_plan.reset_plan()


func _on_UploadButton_pressed():
	if engine_plan.sanity_check():
		rpc_id( 1, "get_plan", [engine_plan] )
