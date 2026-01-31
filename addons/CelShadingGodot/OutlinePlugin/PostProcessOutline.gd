@tool
class_name PostProcessOutlines extends MeshInstance3D

@export_group("OutlineParameters")
@export_range(0.0, 2.0) var normal_threshold: float = 0.3
@export_range(0.0, 2.0) var depth_threshold: float = 0.2
@export_range(0.1, 10.0) var contrast: float = 1.0
@export_range(0.1, 1000.0) var intensity: float = 10.0
@export_range(0.1, 1000.0) var max_distance_threshold: float = 10.0
@export var outline_colors: Vector4 = Vector4(0.0, 0.0, 0.0, 1.0)
@export var outline_size: int = int(1)
@export var resolution_unit: int = int(1920)

# Called when the node enters the scene tree for the first time.
func _ready():
    var quadMesh = QuadMesh.new()
    var materialOutline = ShaderMaterial.new()
    var shaderOutline = preload("res://addons/CelShadingGodot/OutlinePlugin/shader/cell_shading_post_process.gdshader")
    materialOutline.shader = shaderOutline
    quadMesh.material = materialOutline
    quadMesh.size.x = 2.0
    quadMesh.size.y = 2.0
    quadMesh.flip_faces = true
    mesh = quadMesh
    extra_cull_margin = 16384


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var ratio = 1.0
    if Engine.is_editor_hint():
        ratio = EditorInterface.get_editor_viewport_3d(0).size.x
    else:
        ratio = get_viewport().get_visible_rect().size.x
    ratio = ratio / (resolution_unit as float)
    var outline_size_resolution = max(floor(outline_size * get_viewport().get_visible_rect().size.x / (resolution_unit as float)) as int, 1)
    mesh.material.set_shader_parameter("threshold", normal_threshold)
    mesh.material.set_shader_parameter("depth_threshold", depth_threshold)
    mesh.material.set_shader_parameter("contrast", contrast)
    mesh.material.set_shader_parameter("intensity", intensity)
    mesh.material.set_shader_parameter("max_distance_threshold", max_distance_threshold)
    mesh.material.set_shader_parameter("outline_colors", outline_colors)
    mesh.material.set_shader_parameter("iOutlineSize", outline_size_resolution)
