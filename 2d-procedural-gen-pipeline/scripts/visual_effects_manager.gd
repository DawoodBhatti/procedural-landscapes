extends Node2D

@onready var loading_wheel = $LoadingWheel
@onready var signals = $"../SignalManager"

func _ready() -> void:
	#offsets to set to the center
	loading_wheel.position = Vector2(0,0)
	signals.zoom_changed.connect(_on_zoom_changed)


func _on_zoom_changed(zoom : float):
	print("new zoom received:", zoom)
	_adjust_component_zoom(zoom)
	
	
func _adjust_component_zoom(zoom : float):
	#inverted because values between 0 and 1 represent zooming out and thus scren effects need to be made bigger
	loading_wheel.scale_factor = 1/zoom

## public APIs ##
func start_loading_wheel() -> void:
	loading_wheel.start()
	
func stop_loading_wheel() -> void:
	loading_wheel.stop()
