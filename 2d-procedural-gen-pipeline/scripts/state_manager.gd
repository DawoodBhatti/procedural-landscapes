extends Node

# This script manages the state of the visual editor
# It listens for signals and updates UI segments based on selected phases and distribution types

@onready var signals = %SignalManager
@onready var seeding_segment = %SeedingSegment
@onready var random_dist_segment = %RandomDist

# Gen phase states
var seeding_active = false
var other_active = false


# Distribution type state
var random_active = false
var fibonacci_active = false
var poisson_active = false
var halton_active = false
var circular_active = false



func _ready() -> void:
	signals.dist_type_selected.connect(Callable(self, "_on_dist_type_selected"))
	signals.gen_phase_selected.connect(Callable(self, "_on_gen_phase_selected"))

	# Optionally trigger initial state update
	update_editor_state()


func _on_gen_phase_selected(item: String) -> void:
	seeding_active = (item == "Seeding")
	other_active = (item == "Other")
	
	update_editor_state()


func _on_dist_type_selected(item: String) -> void:
	random_active = (item == "Random")
	fibonacci_active = (item == "Fibonacci")
	poisson_active = (item == "Poisson Disk")
	halton_active = (item == "Halton Sequence")
	circular_active = (item == "Circular")
	
	update_editor_state()


func update_editor_state() -> void:
	# Update visibility and logic for each segment
	seeding_segment.visible = seeding_active
	seeding_segment.set_process(seeding_active)
	
	random_dist_segment.visible = (seeding_active && random_active)
	random_dist_segment.set_process(seeding_active && random_active)
