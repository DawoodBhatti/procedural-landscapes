extends Node2D

@onready var loading_wheel = $LoadingWheel

#this class manages on screen effects. maybe this will also manage the animations?


func _ready() -> void:
	#offsets to set to the center
	loading_wheel.position = Vector2(0,0)


## public APIs ##
func start_loading_wheel() -> void:
	loading_wheel.start()
	
	
func stop_loading_wheel() -> void:
	loading_wheel.stop()
