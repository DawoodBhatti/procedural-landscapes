extends Node

# This script manages the visibility state of elements within the visual editor.
# It listens for signals and updates UI segments visibility based on selected
# generation phases and distribution types.

@onready var signals = $"../../SignalManager"
@onready var seeding_segment = %SeedingSegment
@onready var random_dist_segment = %RandomDist
@onready var position_manager = %PositionManager

# Track current generation phase and sub-phase
var active_gen_phase: String = ""
var active_sub_phase: String = ""

# Optional: define known phases and sub-phases for validation or UI logic
const GEN_PHASES = ["Seeding", "Connecting", "Other"]
const SUB_PHASES = ["Random", "Fibonacci", "Poisson Disk", "Halton Sequence", "Circular"]

func _ready() -> void:
	signals.gen_phase_selected.connect(_on_gen_phase_selected)
	signals.dist_type_selected.connect(_on_dist_type_selected)
	update_editor_state()


func _on_gen_phase_selected(phase: String) -> void:
	if phase in GEN_PHASES:
		active_gen_phase = phase
	else:
		push_warning("Unknown generation phase: %s" % phase)
	update_editor_state()


func _on_dist_type_selected(sub_phase: String) -> void:
	if sub_phase in SUB_PHASES:
		active_sub_phase = sub_phase
	else:
		push_warning("Unknown distribution type: %s" % sub_phase)
	update_editor_state()


func update_editor_state() -> void:
	# Seeding segment is only visible during the Seeding phase
	var is_seeding = (active_gen_phase == "Seeding")
	seeding_segment.visible = is_seeding
	seeding_segment.set_process(is_seeding)

	# Random distribution segment is only active during Seeding + Random
	var is_random = (active_sub_phase == "Random")
	random_dist_segment.visible = is_seeding and is_random
	random_dist_segment.set_process(is_seeding and is_random)

	# Update layout or button positions
	position_manager.update_button_positions()
