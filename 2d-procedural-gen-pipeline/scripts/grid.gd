extends Node2D

# Grid state and appearance settings
var grid_state : bool = true
var grid_start : Vector2 = Vector2.ZERO
var grid_end   : Vector2 = Vector2.ZERO

# Minor/major line colors — share alpha for fade effect
var grid_color_minor: Color = Color(0, 0, 0, 0.2)  # faint minor lines
var grid_color_major: Color = Color(0, 0, 0, 0.5)  # stronger major lines
var grid_halfwidth : float = 1.0

# Tile size in pixels at zoom = 1
const TILE_SIZE : float = 10.0

# Major line frequency (every N tiles draw a stronger line)
const MAJOR_LINE_EVERY : int = 10

#we draw the grid in 4 quadrants from the origin to avoid offset issues
func _draw() -> void:
	if grid_color_major.a <= 0.01:
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
		var color := grid_color_minor
		if i % MAJOR_LINE_EVERY == 0:
			color = grid_color_major
		draw_line(Vector2(x, bg_top_left.y), Vector2(x, bg_bottom_right.y), color, grid_halfwidth)
#

	# Center to left - vertical grid lines 
	for i in range(1, int(num_x) + 1):
		var x := map_origin.x - i * TILE_SIZE
		var color := grid_color_minor
		if i % MAJOR_LINE_EVERY == 0:
			color = grid_color_major
		draw_line(Vector2(x, bg_top_left.y), Vector2(x, bg_bottom_right.y), color, grid_halfwidth)


	# Center to bottom - horizontal grid lines 
	for j in range(0, int(num_y) + 1):
		var y := map_origin.y + j * TILE_SIZE
		var color := grid_color_minor
		if j % MAJOR_LINE_EVERY == 0:
			color = grid_color_major
		draw_line(Vector2(bg_top_left.x, y), Vector2(bg_bottom_right.x, y), color, grid_halfwidth)


	# Center to top - horizontal grid lines 
	for j in range(1, int(num_y) + 1):
		var y := map_origin.y - j * TILE_SIZE
		var color := grid_color_minor
		if j % MAJOR_LINE_EVERY == 0:
			color = grid_color_major
		draw_line(Vector2(bg_top_left.x, y), Vector2(bg_bottom_right.x, y), color, grid_halfwidth)


	# === Red axis lines through shape_center ===
	var red_color := Color(1, 0, 0, 1.0)
	draw_line(Vector2(map_origin.x, bg_top_left.y), Vector2(map_origin.x, bg_bottom_right.y), red_color, grid_halfwidth * 1.5)
	draw_line(Vector2(bg_top_left.x, map_origin.y), Vector2(bg_bottom_right.x, map_origin.y), red_color, grid_halfwidth * 1.5)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_grid"):
		grid_state = !grid_state
		if grid_state:
			fade_in_grid()
		else:
			fade_out_grid()


func fade_out_grid() -> void:
	await get_tree().process_frame
	while grid_color_major.a > 0.01:
		grid_color_major.a *= 0.96
		grid_color_minor.a *= 0.96
		queue_redraw()
		await get_tree().process_frame


func fade_in_grid() -> void:
	await get_tree().process_frame
	while grid_color_major.a < 0.49:
		grid_color_major.a *= 1.04
		grid_color_minor.a *= 1.04
		queue_redraw()
		await get_tree().process_frame
