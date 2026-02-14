class_name World
extends Node3D
## Manages nodes in the global world


# ------- Overriden Engine Functions -------
func _ready() -> void:
    if RenderingServer.get_current_rendering_method() == "gl_compatibility":
        var lights = get_tree().get_nodes_in_group("light") as Array[SpotLight3D]
        for light in lights:
            light.light_energy *= 0.


func _process(_delta: float) -> void:
    pass
