extends Panel

@onready var signals: Node = $"../../SignalManager"
@onready var bg: Control = $".."

var zoom_scale: float = 1.5
var small: Vector2 = Vector2(600, 400)
var medium: Vector2 = Vector2(1000, 600)
var large: Vector2 = Vector2(1400, 800)

func _ready() -> void:
	await get_tree().process_frame
	signals.dist_area_selected.connect(_draw_spawn_area)
	signals.zoom_changed.connect(_on_zoom_changed)

	# Override default panel style with transparent background
	var transparent_style: StyleBoxFlat = StyleBoxFlat.new()
	transparent_style.bg_color = Color(0, 0, 0, 0)  # fully transparent
	add_theme_stylebox_override("panel", transparent_style)

	size = small
	_reposition_area()
	_show_area()

func _draw_spawn_area(size_chosen: String) -> void:
	match size_chosen:
		"Small":
			size = small
		"Medium":
			size = medium
		"Large":
			size = large
		_:
			return
	_reposition_area()
	_show_area()
	queue_redraw()

func _show_area() -> void:
	visible = true

func _hide_area() -> void:
	visible = false

func _reposition_area() -> void:
	position = bg.size / 2 - size / 2

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var dash_length: float = 10.0
	var gap_length: float = 6.0
	var thickness: float = 2.0 * zoom_scale
	var scroll_speed: float = 40.0  # pixels per second
	var color: Color = Color(0.2, 0.4, 1.0)  # blue

	var dash_cycle: float = dash_length + gap_length
	var elapsed_time: float = Time.get_ticks_msec() / 1000.0
	var dash_phase: float = fmod(elapsed_time * scroll_speed, dash_cycle)

	var rect: Rect2 = Rect2(Vector2.ZERO, size)
	var points: Array[Vector2] = [
		rect.position,
		rect.position + Vector2(rect.size.x, 0),
		rect.position + rect.size,
		rect.position + Vector2(0, rect.size.y)
	]

	for i: int in range(4):
		var a: Vector2 = points[i]
		var b: Vector2 = points[(i + 1) % 4]
		var dir: Vector2 = (b - a).normalized()
		var length: float = a.distance_to(b)
		var drawn: float = -dash_phase

		while drawn < length:
			var start_offset: float = max(0.0, drawn)
			var seg_len: float = min(dash_length, length - start_offset)
			if seg_len > 0.0:
				var start_pos: Vector2 = a + dir * start_offset
				var end_pos: Vector2 = start_pos + dir * seg_len
				draw_line(start_pos, end_pos, color, thickness)
			drawn += dash_cycle


func _on_zoom_changed(zoom_factor: float) -> void:
	
	#resize the thickness of the dashed lines
	if zoom_factor < 0.5:
		zoom_scale = 2.2
	else:
		zoom_scale = 1.1
	
	queue_redraw()
