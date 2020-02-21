extends Node2D



# [OPTIONAL] only functions to move screen on drag
var is_pressed: bool = false
var swipe_start: Vector2 = Vector2.ZERO
var minimum_drag: int = 100

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			is_pressed = get_global_mouse_position().x
			swipe_start = get_global_mouse_position()
		else:
			swipe_start = Vector2.ZERO
	
	if event is InputEventScreenDrag:
		_calculate_swipe(get_global_mouse_position())
	
func _calculate_swipe(swipe_end):
	if swipe_start == Vector2.ZERO: 
		return
	var swipe = swipe_end - swipe_start
	if abs(swipe.x) > minimum_drag:
		$camera._move(-sign(swipe.x))
