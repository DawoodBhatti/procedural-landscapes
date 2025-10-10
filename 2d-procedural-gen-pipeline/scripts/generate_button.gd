extends Button

@onready var signals = get_tree().root.get_node("main/SignalManager")
@onready var state_manager = %StateManager

#here we control the formatting for the go and back buttons
func _ready() -> void:
	
	connect("pressed", Callable(self, "_on_go_button_pressed"))
	_apply_go_button_style()


func _apply_go_button_style() -> void:
	theme = null
	
	#disables grey outline that shows when clicked
	focus_mode = Control.FOCUS_NONE

	var green_bg := Color("#008500")       # Semi-transparent dark green background  
	var green_text := Color("#008500")     # Semi-transparent bright green text  
	var grey_bg := Color("f8f8f8ff")          # Light grey background (unchanged)  
	var faded_green := Color("#008500")    # Very faded deep green
	
	var normal := StyleBoxFlat.new()
	normal.bg_color = green_bg
	normal.corner_radius_top_left = 8
	normal.corner_radius_top_right = 8
	normal.corner_radius_bottom_left = 8
	normal.corner_radius_bottom_right = 8

	var hover := normal.duplicate()
	hover.bg_color = grey_bg

	var pressed := normal.duplicate()
	pressed.bg_color = grey_bg

	var disabled := normal.duplicate()
	disabled.bg_color = faded_green

	add_theme_stylebox_override("normal", normal)
	add_theme_stylebox_override("hover", hover)
	add_theme_stylebox_override("pressed", pressed)
	add_theme_stylebox_override("disabled", disabled)

	add_theme_font_override("font", ThemeDB.fallback_font)
	add_theme_color_override("font_color", Color.WHITE)
	add_theme_color_override("font_hover_color", green_text)
	add_theme_color_override("font_pressed_color", green_text)
	add_theme_color_override("font_disabled_color", Color(1, 1, 1, 0.5))


#emit appropriate gen request signal
func _on_go_button_pressed() -> void:
	
	#find out what phase we are in, from the state manager
	if state_manager.active_gen_phase == "Seeding":
		if state_manager.active_sub_phase == "Random":
			var num_points = int(%RandomDist.get_node("Parameters/Values/NumPoints").text)
			var seed_num = int(%RandomDist.get_node("Parameters/Values/NumPoints").text)
			signals.emit_logged("rand_dist_requested", [num_points, seed_num])
