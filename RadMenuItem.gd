extends Control

var angle = null
var origin = null
var radius = 0
var color = Color.PINK
var letter_val = "f"
# Called when the node enters the scene tree for the first time.
func set_data(_angle, _origin, _radius, letter ):
	radius = _radius
	angle = _angle
	origin = _origin
	letter_val = letter

func get_letter():
	return letter_val

func set_color(_color):
	color = _color
	queue_redraw()
func _ready():
	get_node("TextureRect/Letter").text = letter_val
	pass # Replace with function body.

func _draw():
	var endpoint_x = origin.x + (radius * cos(deg_to_rad(angle - 15)))
	var endpoint_y = origin.y + (radius * sin(deg_to_rad(angle - 15)))
	var endpoint = Vector2(endpoint_x, endpoint_y)
	draw_line(origin, endpoint, color)
	
	endpoint_x = origin.x + (radius * cos(deg_to_rad(angle + 15)))
	endpoint_y = origin.y + (radius * sin(deg_to_rad(angle + 15)))
	endpoint = Vector2(endpoint_x, endpoint_y)
	draw_line(origin, endpoint, color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
