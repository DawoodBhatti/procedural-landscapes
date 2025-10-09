extends ColorRect

@export var scale_factor: float = 2.0
var shape_center: Vector2


func _ready() -> void:
	size = get_viewport().size * scale_factor
	
	# position sets the top left corner point of the ColorRect node
	#so here we center the color rectangle at global position (0, 0)
	position = -size/2  
	
	#and we set the local shape center which can be accessed by other code
	shape_center = size/2
	
	set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
