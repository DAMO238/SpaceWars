extends "res://PlanElement.gd"

var thrust_direction = Vector3( 1, 0, 0 )
var thrust_percentage = 100

var rot_axis = Vector3( 1, 0, 0 )
var rot_percentage = 100
var torque_direction = Quat( rot_axis, rot_percentage )

func init():
	type = 'thrust'

func update_torque():
	torque_direction = Quat( rot_axis, rot_percentage )

func sanity_check():
	if thrust_percentage > 100:
		thrust_percentage = 100
		return true
	if rot_percentage > 100:
		rot_percentage = 100
		return true
	return true