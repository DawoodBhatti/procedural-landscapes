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
const TILE_SIZE : float = 16.0

# Major line frequency (every N tiles draw a stronger line)
const MAJOR_LINE_EVERY : int = 10

func _draw() -> void:
	if grid_color_major.a > 0.01:
		var bg := %Background
		var map_origin: Vector2 = bg.shape_center

		# Get background bounds in global space
		var bg_top_left: Vector2 = bg.global_position
		var bg_bottom_right: Vector2 = bg.global_position + bg.size

		# Snap bounds to tile grid
		var start_x: float = floor((bg_top_left.x + map_origin.x) / TILE_SIZE) * TILE_SIZE
		var end_x: float   = ceil((bg_bottom_right.x + map_origin.x) / TILE_SIZE) * TILE_SIZE
		var start_y: float = floor((bg_top_left.y + map_origin.y) / TILE_SIZE) * TILE_SIZE
		var end_y: float   = ceil((bg_bottom_right.y + map_origin.y) / TILE_SIZE) * TILE_SIZE

		# Vertical lines
		for x in range(int(start_x), int(end_x) + 1, int(TILE_SIZE)):
			var color: Color = grid_color_minor
			if int(floor((x - map_origin.x) / TILE_SIZE)) % MAJOR_LINE_EVERY == 0:
				color = grid_color_major
			grid_start = Vector2(x, start_y)
			grid_end   = Vector2(x, end_y)
			draw_line(grid_start, grid_end, color, grid_halfwidth)

		# Horizontal lines
		for y in range(int(start_y), int(end_y) + 1, int(TILE_SIZE)):
			var color: Color = grid_color_minor
			if int(floor((y - map_origin.y) / TILE_SIZE)) % MAJOR_LINE_EVERY == 0:
				color = grid_color_major
			grid_start = Vector2(start_x, y)
			grid_end   = Vector2(end_x, y)
			draw_line(grid_start, grid_end, color, grid_halfwidth)


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
