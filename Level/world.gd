class_name World
extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if RenderingServer.get_current_rendering_method() == "gl_compatibility":
        var lights = get_tree().get_nodes_in_group("light") as Array[SpotLight3D]
        for light in lights:
            light.light_energy *= 0.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
