class_name PlayerStart
extends Node3D

# ------- Internal vars -------
var _starting_transform := Transform3D.IDENTITY


@onready var _ray_cast_3d := $RayCast3D as RayCast3D


# ------- Overriden Engine Functions -------
func _ready() -> void:
    _ray_cast_3d.force_raycast_update()
    _starting_transform = _compute_starting_transform()


# ------- Other Functions -------
func get_starting_transform() -> Transform3D:
    return _starting_transform


func _compute_starting_transform() -> Transform3D:
    if not _ray_cast_3d.is_colliding():
        _ray_cast_3d.enabled = false
        return global_transform

    var collision_point := _ray_cast_3d.get_collision_point()
    var result := global_transform
    result.origin = collision_point

    _ray_cast_3d.enabled = false
    return result
