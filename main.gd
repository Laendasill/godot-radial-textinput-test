extends Node2D
@onready var screen_size = get_viewport_rect().size
var menu_item = load("res://rad_menu_item.tscn")
var controller_line = load("res://controller_line.tscn")
var nodes = []
var angle_pairs = []
var last_entered = null
var stick_active = false
var letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","m"]
var current_text = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	var num_lines = 12
	var radius = 300
	var angle_per_line = 360.0 / num_lines
	var origin = screen_size / 2
	for i in num_lines:
		var a = menu_item.instantiate()
		nodes.append(a)
		var angle = i * angle_per_line
		angle_pairs.append([angle - 15, angle + 15])
		a.set_data(i*angle_per_line, origin, 250, letters[i])
		add_child(a)
	var cl = controller_line.instantiate()
	cl.set_data(origin)
	cl.angle_time.connect(handle_angle_change)
	cl.is_stick_active.connect(handle_stick_active)
	add_child(cl)
func _draw():
	#draw_circle(screen_size / 2, 300 * 0.4, Color.WHITE)
	draw_arc(screen_size / 2, 300 * 0.4, 0, 360, 360, Color.WHITE)
func handle_stick_active(is_active):
	if not stick_active and is_active:
		stick_active = is_active
	if stick_active and not is_active:
		stick_active = is_active
		current_text += nodes[last_entered].get_letter()
		$InputText.text = "InputText: " + current_text

func handle_angle_change(angle):
	$CurrentAngle.text = str("angle: ") + str(angle)
	for i in range(len(angle_pairs)):
		if angle > angle_pairs[i][0] and angle < angle_pairs[i][1]:
			var entered = i
			if not entered == last_entered:
				last_entered = entered
				print(last_entered)
				nodes[i].set_color(Color.GREEN)
			else:
				nodes[i].set_color(Color.PINK)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
