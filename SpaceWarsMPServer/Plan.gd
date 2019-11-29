class_name Plan

const TURN_TIME = 5
var allowed_elements = []
var elements = []

func init(_allowed_elements):
	allowed_elements = _allowed_elements

func sanity_check():
	var time = 0
	for element in elements:
		time += element.time
		if !element.sanity_check():
			return false
		if !allowed_elements.has(element.type):
			return false
	if time > TURN_TIME:
		return false
	return true


func add_element(element):
	elements.append(element)


func remove_last_element():
	elements.remove( -1 )


func reset_plan():
	elements = []