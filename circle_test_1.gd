extends Control
@onready var screen_size = get_viewport_rect().size




var num_lines = 12
var radius = 300
var angle_per_line = 360.0 / num_lines
var nodes = []
var tans = []
var current_angle = 0
var stick_active = false
# Called when the node enters the scene tree for the first time.
var draw_item_lines = []
func _ready():
	var origin = screen_size / 2
	for i in range(num_lines):
		var angle = i * angle_per_line
		var endpoint_x = origin.x + (radius * cos(deg_to_rad(angle)))
		var endpoint_y = origin.y + (radius * sin(deg_to_rad(angle)))
		var endpoint = Vector2(endpoint_x, endpoint_y)
		draw_item_lines.append({
			'a': origin,
			'b': endpoint,
			'color': Color.RED,
			'angle': angle
		})
	
	pass # Replace with function body.

	

func get_color_for_angle(idx):
	var angle = draw_item_lines[idx]['angle']
	return Color.RED
	if angle == 0:
		return Color.BLUE_VIOLET
	if angle == 30:
		return Color.YELLOW
	if angle == 180:
		return Color.CYAN
	return Color.RED
func calc_closes_indexes2():
	var idx1 = -1 
	var sdiff1 = 400
	for i in range(len(draw_item_lines)):
		draw_item_lines[i]['color'] = Color.RED
		var item1 = draw_item_lines[i-1]
		var item2 = draw_item_lines[i]
		var ang = current_angle
		if ang < 0:
			ang = ang + 360
		var twangle = item2['angle']
		if twangle == 0:
			twangle = 360
			
			print(str(item1['angle']) + " " + str(ang) )
		if item1['angle'] < ang and twangle >= ang:
			item1['color'] = Color.GREEN
			item2['color'] = Color.GREEN
		else:
			item2['color'] = get_color_for_angle(i)

func _draw():
	var origin = screen_size / 2
	for i in range(num_lines):
		var item = draw_item_lines[i]
		draw_line(item['a'], item['b'], item['color'])
	if stick_active:
		draw_line(origin, _pos_as_angle(200), Color.GREEN)
func _input(event):
	if event is InputEventJoypadMotion:
		pass
#		print("test")
#		if event.axis == 0:
#			var left_stick = event.axis_value
#			var left_stick_angle = atan2(left_stick.y, left_stick.x)
#			$Label.text = left_stick_angle
#		if event.axis == 1:
#			var left_stick = event.axis_value
#			var left_stick_angle = atan2(left_stick.y, left_stick.x)
#			$Label.text = left_stick_angle
		
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _pos_as_angle(times):
	var origin = screen_size / 2
	var xAxis = Input.get_joy_axis(0,JOY_AXIS_LEFT_X)
	var yAxis = Input.get_joy_axis(0,JOY_AXIS_LEFT_Y)
	var left_stick_angle = atan2(yAxis, xAxis)
	var x = origin.x + (times * cos(left_stick_angle))
	var y = origin.y + (times * sin(left_stick_angle))
	return Vector2(x, y)

func _process(delta):
	var origin = screen_size / 2
	if Input.get_connected_joypads().size() > 0:
		var xAxis = Input.get_joy_axis(0,JOY_AXIS_LEFT_X)
		var yAxis = Input.get_joy_axis(0,JOY_AXIS_LEFT_Y)
		if abs(xAxis) > 0.1 or abs(yAxis) > 0.1:
			stick_active = true
		else:
			stick_active = false
		current_angle = snapped(rad_to_deg(atan2(yAxis, xAxis)), 0.01)
		$Label.text = str("x: ") + str(snapped(xAxis, 0.01)) + " y: " + str(snapped(yAxis, 0.01)) + " atan: " +str(current_angle + 360)
	
	calc_closes_indexes2()
	queue_redraw()
