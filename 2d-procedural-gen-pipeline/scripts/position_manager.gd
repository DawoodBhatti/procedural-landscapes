extends Node

#here we handle logic for item locations within the Generation panel group
#such as the positioning of elements relative to one another

@onready var random_dist_segment = %RandomDist
@onready var generate_button = %GenerateButton

# on screen positioning
var random_dist_segment_position : Vector2

func _ready() -> void:
	random_dist_segment_position = get_node("../GenerationPanel/SeedingSegment/RandomDist/Parameters").position
	

#update position and visiblity of gen button
func _update_gen_button_state() -> void:
	if random_dist_segment.visible == true:
		
		print("we'll move the button below the random thing")
		generate_button.visible = true
		generate_button.set_position(random_dist_segment_position + Vector2(50,180))
	else:
		generate_button.visible = false


## public apis ##

func update_button_positions() -> void:
	_update_gen_button_state()
