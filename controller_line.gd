extends Control

var origin = null
var stick_active = null
var current_angle = null
var dead_zone = 0.4

signal angle_time(angle)
signal is_stick_active(active)
# Called when the node enters the scene tree for the first time
func set_data(_origin):
	origin = _origin

func _ready():
	pass # Replace with function body.

func _draw():
	var axis = get_axis_values()
	var angle = atan2(axis[1],axis[0])
	
	var endpoint = Vector2(
		origin.x + (200 * cos(angle)), 
		origin.y + (200 * sin(angle))
	)
	draw_line(origin, endpoint, Color.YELLOW)
	if stick_active:
		draw_line(origin, _pos_as_angle(200), Color.GREEN)

func get_axis_values():
	var xAxis = Input.get_joy_axis(0,JOY_AXIS_RIGHT_X)
	var yAxis = Input.get_joy_axis(0,JOY_AXIS_RIGHT_Y)
	return [xAxis, yAxis]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _pos_as_angle(times):
	var axis = get_axis_values()
	var left_stick_angle = atan2(axis[1], axis[0])
	var x = origin.x + (times * cos(left_stick_angle))
	var y = origin.y + (times * sin(left_stick_angle))
	return Vector2(x, y)

func _process(delta):
	if Input.get_connected_joypads().size() > 0:
		var axis = get_axis_values()
		if abs(axis[0]) > dead_zone or abs(axis[1]) > dead_zone:
			stick_active = true
		else:
			stick_active = false
		is_stick_active.emit(stick_active)
		if stick_active:
			var new_angle = snapped(rad_to_deg(atan2(axis[1], axis[0])), 0.1)
			if new_angle < 0:
				new_angle += 360
			if not current_angle == new_angle:
				current_angle = new_angle
				angle_time.emit(current_angle)
		queue_redraw()
