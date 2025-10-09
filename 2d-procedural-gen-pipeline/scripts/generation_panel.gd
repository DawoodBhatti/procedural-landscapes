extends CanvasLayer

@onready var generate_button: Button = $GenerateButton
@onready var signals: Node = %SignalManager

#here we control the formatting for the go and back buttons
func _ready() -> void:
	
	generate_button.connect("pressed", Callable(self, "_on_go_button_pressed"))
	_apply_go_button_style()



func _apply_go_button_style() -> void:
	generate_button.theme = null

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

	generate_button.add_theme_stylebox_override("normal", normal)
	generate_button.add_theme_stylebox_override("hover", hover)
	generate_button.add_theme_stylebox_override("pressed", pressed)
	generate_button.add_theme_stylebox_override("disabled", disabled)

	generate_button.add_theme_font_override("font", ThemeDB.fallback_font)
	generate_button.add_theme_color_override("font_color", Color.WHITE)
	generate_button.add_theme_color_override("font_hover_color", green_text)
	generate_button.add_theme_color_override("font_pressed_color", green_text)
	generate_button.add_theme_color_override("font_disabled_color", Color(1, 1, 1, 0.5))



func _on_go_button_pressed() -> void:
	
	signals.emit_signal("generation_requested")
