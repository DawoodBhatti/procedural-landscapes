extends Node2D

@onready var noise_type_button = %OptionButton
@onready var frequency_slider = %FrequencySlider
@onready var octaves_slider = %OctavesSlider
@onready var lacunarity_slider = %LacunaritySlider
@onready var freq_display: Label = %FreqDisplay
@onready var oct_display: Label = %OctDisplay
@onready var lac_display: Label = %LacDisplay


var fast_noise_lite = FastNoiseLite.new()

func _ready():
	# Initial setup
	_set_initial_values()
	_generate_noise_texture()


func _set_initial_values():
	fast_noise_lite.noise_type = FastNoiseLite.TYPE_CELLULAR
	fast_noise_lite.frequency = frequency_slider.value
	freq_display.text = str(frequency_slider.value)
	fast_noise_lite.fractal_type = FastNoiseLite.FRACTAL_FBM
	fast_noise_lite.fractal_octaves = int(octaves_slider.value)
	oct_display.text = str(octaves_slider.value)
	fast_noise_lite.fractal_lacunarity = lacunarity_slider.value
	lac_display.text = str(lacunarity_slider.value)

func _generate_noise_texture():
	var height = 1024
	var width = 1024

	var noise_image = fast_noise_lite.get_image(height, width)
	var noise_texture = ImageTexture.create_from_image(noise_image)
	$Perlin.texture = noise_texture


# --- UI Callbacks ---
func _on_noise_type_selected(index):
	fast_noise_lite.noise_type = index
	_generate_noise_texture()

func _on_frequency_changed(value):
	fast_noise_lite.frequency = value
	freq_display.text = str(value)
	_generate_noise_texture()

func _on_octaves_changed(value):
	fast_noise_lite.fractal_octaves = int(value)
	oct_display.text = str(value)
	_generate_noise_texture()

func _on_lacunarity_changed(value):
	fast_noise_lite.fractal_lacunarity = value
	lac_display.text = str(value)
	_generate_noise_texture()
