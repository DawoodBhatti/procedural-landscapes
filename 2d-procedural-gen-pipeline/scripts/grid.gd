extends Node2D

@onready var signals: Node = $"../../SignalManager"

# Grid state and appearance settings
var grid_state : bool = true
var grid_start : Vector2 = Vector2.ZERO
var grid_end   : Vector2 = Vector2.ZERO
var zoom_scale : float = 1.0


# Minor/major line colors — share alpha for fade effect
var minor_grid_colour: Color = Color(0, 0, 0, 0.2)  # faint minor lines
var major_grid_colour: Color = Color(0, 0, 0, 0.5)  # stronger major lines
var minor_grid_linewidth : float = 1.0
var major_grid_linewidth : float = minor_grid_linewidth * 1.5 * zoom_scale

# Tile size in pixels at zoom = 1
const TILE_SIZE : float = 10.0

# line frequency (every N tiles draw a strong/light line)
var major_line_every : int = 10
var minor_line_every : int = 1 

func _ready() -> void:
	signals.zoom_changed.connect(_on_zoom_changed)

#we draw the grid in 4 quadrants from the origin to avoid offset issues
func _draw() -> void:
	if major_grid_colour.a <= 0.01:
		return

	var bg := $".."
	var map_origin: Vector2 = bg.shape_center

	# Get background bounds in local space
	var bg_top_left: Vector2 = bg.shape_center - bg.size/2
	var bg_bottom_right: Vector2 =  bg.shape_center + bg.size/2
	

	# Calculate number of tiles from center to edges
	var num_x: float   = ceil((bg_bottom_right.x - map_origin.x) / TILE_SIZE) 
	var num_y: float   = ceil((bg_bottom_right.y - map_origin.y) / TILE_SIZE) 

	# Center to right -  vertical grid lines
	for i in range(0, int(num_x) + 1):
		var x := map_origin.x + i * TILE_SIZE
		if i % major_line_every == 0:
			draw_line(Vector2(x, bg_top_left.y), Vector2(x, bg_bottom_right.y), major_grid_colour, major_grid_linewidth)
		elif i % minor_line_every == 0:
			draw_line(Vector2(x, bg_top_left.y), Vector2(x, bg_bottom_right.y), minor_grid_colour, minor_grid_linewidth)


	# Center to left - vertical grid lines 
	for i in range(1, int(num_x) + 1):
		var x := map_origin.x - i * TILE_SIZE
		if i % major_line_every == 0:
			draw_line(Vector2(x, bg_top_left.y), Vector2(x, bg_bottom_right.y), major_grid_colour, major_grid_linewidth)
		elif i % minor_line_every == 0:
			draw_line(Vector2(x, bg_top_left.y), Vector2(x, bg_bottom_right.y), minor_grid_colour, minor_grid_linewidth)


	# Center to bottom - horizontal grid lines 
	for j in range(0, int(num_y) + 1):
		var y := map_origin.y + j * TILE_SIZE
		if j % major_line_every == 0:
			draw_line(Vector2(bg_top_left.x, y), Vector2(bg_bottom_right.x, y), major_grid_colour, major_grid_linewidth)
		elif j % minor_line_every == 0:
			draw_line(Vector2(bg_top_left.x, y), Vector2(bg_bottom_right.x, y), minor_grid_colour, minor_grid_linewidth)


	# Center to top - horizontal grid lines 
	for j in range(1, int(num_y) + 1):
		var y := map_origin.y - j * TILE_SIZE
		if j % major_line_every == 0:
			draw_line(Vector2(bg_top_left.x, y), Vector2(bg_bottom_right.x, y), major_grid_colour, major_grid_linewidth)
		elif j % minor_line_every == 0:
			draw_line(Vector2(bg_top_left.x, y), Vector2(bg_bottom_right.x, y), minor_grid_colour, minor_grid_linewidth)


	# === Red axis lines through shape_center ===
	var red_color := Color(1, 0, 0, 1.0)
	draw_line(Vector2(map_origin.x, bg_top_left.y), Vector2(map_origin.x, bg_bottom_right.y), red_color, major_grid_linewidth)
	draw_line(Vector2(bg_top_left.x, map_origin.y), Vector2(bg_bottom_right.x, map_origin.y), red_color, major_grid_linewidth)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_grid"):
		grid_state = !grid_state
		if grid_state:
			fade_in_grid()
		else:
			fade_out_grid()


func fade_out_grid() -> void:
	await get_tree().process_frame
	while major_grid_colour.a > 0.01:
		major_grid_colour.a *= 0.96
		minor_grid_colour.a *= 0.96
		queue_redraw()
		await get_tree().process_frame


func fade_in_grid() -> void:
	await get_tree().process_frame
	while major_grid_colour.a < 0.49:
		major_grid_colour.a *= 1.04
		major_grid_colour.a *= 1.04
		queue_redraw()
		await get_tree().process_frame


func _on_zoom_changed(zoom_factor: float) -> void:
	
	#threshold for when we thicken grid lines and change square grouping
	if zoom_factor < 0.3:
		zoom_scale = 2.0
		major_line_every = 20
		minor_line_every = 2

	else:
		zoom_scale = 1.0
		major_line_every = 10
		minor_line_every = 1

	
	major_grid_linewidth = minor_grid_linewidth * 1.5 * zoom_scale

	queue_redraw()
