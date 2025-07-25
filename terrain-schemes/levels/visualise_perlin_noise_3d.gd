extends Node3D

@onready var mesh_instance = $MeshInstance3D

var width = 256
var depth = 256
var height = 50

func _ready():
	var fast_noise_lite = FastNoiseLite.new();
	
	# Set perlin noise parameters
	fast_noise_lite.noise_type = FastNoiseLite.TYPE_PERLIN
	fast_noise_lite.frequency = 0.02
	fast_noise_lite.fractal_type = FastNoiseLite.FRACTAL_FBM
	fast_noise_lite.fractal_octaves = 5
	
	# Create a PlaneMesh and generate the procedural terrain
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(width, depth)
	plane_mesh.subdivide_depth = width - 1
	plane_mesh.subdivide_width = depth - 1

	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, plane_mesh.surface_get_arrays(0))

	# Create SurfaceTool
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Generate vertices based on noise
	for z in range(depth):
		for x in range(width):
			var vertex_position = Vector3(x - width/2, 0, z - depth/2)
			vertex_position.y = fast_noise_lite.get_noise_2d(x, z) * height
			surface_tool.add_vertex(vertex_position)

	# Connect the vertices to form triangles
	for z in range(depth - 1):
		for x in range(width - 1):
			var idx = z * width + x
			surface_tool.add_index(idx)
			surface_tool.add_index(idx + 1)
			surface_tool.add_index(idx + width)
			
			surface_tool.add_index(idx + 1)
			surface_tool.add_index(idx + width + 1)
			surface_tool.add_index(idx + width)

	# Commit the mesh to the MeshInstance3D
	var generated_mesh = surface_tool.commit()
	mesh_instance.mesh = generated_mesh
	
	var light = DirectionalLight3D.new()
	light.position = Vector3(0, 300, 0)
	light.rotation_degrees = Vector3(45, 0, 45)  # Adjust the angle as needed
	light.light_energy = 1.5  # Adjust the intensity of the light
	light.shadow_enabled = true
	light.shadow_bias = 0.05 # Set shadow bias to reduce shadow artifacts like acne
	light.shadow_normal_bias = 0.3 # Adjust shadow normal bias to deal with self-shadowing issues
	light.shadow_blur = 0.3  # Adjust from 0 to 1, where 0 is sharp and 1 is very soft

	add_child(light)
	
	var environment = WorldEnvironment.new()
	var env_resource = Environment.new()
	env_resource.set_ambient_light_color(Color(0.5, 0.5, 0.5))
	env_resource.set_ambient_light_energy(0.5)  # Adjust for stronger or weaker ambient light
	environment.environment = env_resource
	add_child(environment)
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.4, 0.8, 0.2)  # A greenish color for grass, for example
	material.roughness = 1.0  # Matte finish
	mesh_instance.material_override = material
