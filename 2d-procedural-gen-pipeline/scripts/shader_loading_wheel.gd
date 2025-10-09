extends ColorRect

@onready var shader_material : ShaderMaterial = material

func _ready():
	size = get_viewport().size
	position = Vector2.ZERO
	
	shader_material.set_shader_parameter("screen_size", Vector2(size.x, size.y))
	shader_material.set_shader_parameter("screen_ratio", Vector2(size.x / size.y, 1.0))
	shader_material.set_shader_parameter("center", Vector2(0.5, 0.5))
	shader_material.set_shader_parameter("radius", 90.0)
	shader_material.set_shader_parameter("blur_radius", 10.0)
	shader_material.set_shader_parameter("trail_length", 15)
	shader_material.set_shader_parameter("rotation_speed", 0.2)
	shader_material.set_shader_parameter("hue_rate", 0.02) # Try 0.1–1.0 for visible fade

func _process(delta):
	shader_material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)
