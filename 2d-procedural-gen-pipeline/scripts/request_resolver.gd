extends Node

var currently_resolving: bool = false

func _ready() -> void:
	pass
	
	
## public apis ##

func is_rand_dist_request_allowed( num_point: int, seed_num: int ) -> bool:
	
	#is anything else currently resolving?
	if currently_resolving == true:
		return false
		
	currently_resolving = true
	#start the calculations...
	
	return true
