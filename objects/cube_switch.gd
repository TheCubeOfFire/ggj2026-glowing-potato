class_name CubeSwitch
extends StaticBody3D

# ------- Signal -------
signal on_activated()

signal on_deactivated()

# ------- Exposed vars -------
@export var accepted_cube_type := Globals.GCUBE_TYPE.SQUARE


# ------- Internal vars -------
## Number of cubes that are of the accepted type AND in the detection area
var _current_activating_cubes : int = 0


# ------- Overriden Engine Functions -------
func _ready() -> void:
    match accepted_cube_type:
        Globals.GCUBE_TYPE.SQUARE:
            $Square_Switch.mesh = load(&"uid://cpw1b3ay6o681")
            pass

        Globals.GCUBE_TYPE.TRIANGLE:
            $Square_Switch.mesh = load(&"uid://b2md5rkxvaopn")
            pass

        Globals.GCUBE_TYPE.CIRCLE:
            $Square_Switch.mesh = load(&"uid://eg6imty2sgjw")
            pass
    return


# ------- Functions -------
#region cube detection
func _on_cube_detection_area_body_entered(body: Node3D) -> void:
    if body is GravityCube:
        var gravity_cube := body as GravityCube
        if accepted_cube_type != gravity_cube.cube_type:
            return

        add_activating_cube()
    return


func _on_cube_detection_area_body_exited(body: Node3D) -> void:
    if body is GravityCube:
        var gravity_cube := body as GravityCube
        if accepted_cube_type != gravity_cube.cube_type:
            return

        remove_activating_cube()
    return
#endregion


func get_current_activating_cubes() -> int:
    return _current_activating_cubes

func add_activating_cube() -> void:
    _current_activating_cubes += 1
    if _current_activating_cubes == 1:
        on_activated.emit()
    return

func remove_activating_cube() -> void:
    assert(_current_activating_cubes > 0)
    _current_activating_cubes -= 1
    if _current_activating_cubes == 0:
        on_deactivated.emit()
    return
