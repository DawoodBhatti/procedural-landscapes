extends Node2D

var radius := 75.0
var angle := 0.0
var speed := 3.0  # degrees per frame
var spinning := false
var trail := []
var stagger : int = 100
var scale_factor = 1.0

var hue := 0.0
const MAX_TRAIL_LENGTH := 105
const HUE_SPEED := 0.001  # slow fade

#set load icon to middle of viewport
func _ready():

	position = get_viewport().size/2


func _process(delta):
	if spinning:
		angle += speed
		if angle >= 360:
			angle -= 360

		hue += HUE_SPEED
		if hue > 1.0:
			hue -= 1.0

		var rad = deg_to_rad(angle)
		var pos = Vector2(cos(rad), sin(rad)) * radius * scale_factor/2
		var color = Color.from_hsv(hue, 1.0, 1.0)

		trail.insert(0, { "pos": pos, "color": color })
		if trail.size() > MAX_TRAIL_LENGTH:
			trail.pop_back()

		queue_redraw()


func _draw():
	for i in range(trail.size()):
		var alpha = 1.0 - float(i) / MAX_TRAIL_LENGTH
		var c = trail[i]["color"]
		draw_circle(trail[i]["pos"], 10*scale_factor/2, Color(c.r, c.g, c.b, alpha))


func start():
	spinning = true


func stop():
	spinning = false
	trail.clear()
	queue_redraw()
