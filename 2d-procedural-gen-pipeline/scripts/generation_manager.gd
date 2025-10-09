extends Node


#GenerationManager will handle the procedural generation requests 
#it will interface between requests (from UI or system) and the GenEngine


@onready var signals = get_tree().root.get_node("main/SignalManager")
@onready var resolve = $RequestResolver

func _ready() -> void:
	signals.rand_dist_requested.connect(_on_rand_dist_requested)
	pass
	

func _on_rand_dist_requested(num_points: int, seed_num: int) -> void:
	
	print("here we will confer with the req resolver")
	print("to generate a random distribution")
	
	if $RequestResolver.is_rand_dist_request_allowed(num_points, seed_num) == true:
		print("allowed!")
		
		#here we'll make the request to the GenEngine
		#but a placeholder in the meantime is the loading wheel
		$"../VisualEffectsManager".start_loading_wheel()
	else:
		#a placeholder in the meantime is the loading wheel turning off
		$RequestResolver.currently_resolving = false
		$"../VisualEffectsManager".stop_loading_wheel()
