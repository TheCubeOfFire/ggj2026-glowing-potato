class_name GravityCube
extends RigidBody3D

# ------- Internal vars -------
@onready var default_gravity_force: float = ProjectSettings.get_setting(&"physics/3d/default_gravity")
@onready var default_gravity_vector: Vector3 = ProjectSettings.get_setting(&"physics/3d/default_gravity_vector")

var is_gravity_overrriden: bool = false
var gravity_override: Vector3 = Vector3.ZERO

# ------- Overriden Engine Functions -------
func _physics_process(_delta: float) -> void:
    if is_gravity_overrriden:
        apply_central_force(default_gravity_force * default_gravity_vector * -1)
        apply_central_force(default_gravity_force * gravity_override)
    return

# ------- Functions -------
func override_gravity(new_gravity: Vector3) -> void:
    is_gravity_overrriden = true
    gravity_override = new_gravity.normalized()
    return

func clear_gravity_override() -> void:
    is_gravity_overrriden = false
    gravity_override = Vector3.ZERO
    return
