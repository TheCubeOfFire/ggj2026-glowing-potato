class_name GravityCube
extends AnimatableBody3D
## A movable cube, that can be moved using the masks to power [CubeSwitch]es

# ------- Exposed vars -------
## Type of this cube, sets the displayed mesh
@export var cube_type := Globals.GCUBE_TYPE.SQUARE

## Default force that is applied when moving this cube
@export var default_gravity_force: float
## Default friction used to smooth movement
@export var friction: float


# ------- Internal vars -------
## Array of all forces that are currently applied to this cube
var _applied_forces: Array[Vector3] = []
## Current sum of all applied forces, normalized
var _curr_combined_force: Vector3 = Vector3.ZERO
## Current velocity of the cube
var _velocity := Vector3.ZERO


@onready var _mesh_instance := $MeshInstance3D as MeshInstance3D


# ------- Overriden Engine Functions -------
func _ready() -> void:
    Globals.on_level_reset.connect(_level_reset_behavior)
    match cube_type:
        Globals.GCUBE_TYPE.SQUARE:
            $MeshInstance3D.mesh = load(&"uid://bxowgvli1ufmb")
            pass

        Globals.GCUBE_TYPE.TRIANGLE:
            $MeshInstance3D.mesh = load(&"uid://dr60osaps5r7t")
            pass

        Globals.GCUBE_TYPE.CIRCLE:
            $MeshInstance3D.mesh = load(&"uid://dt4ab4uarcxsw")
            pass
    return

func _physics_process(delta: float) -> void:
    var gravity_acceleration := default_gravity_force * _curr_combined_force
    _velocity *= 1.0 - friction
    _velocity += gravity_acceleration * delta

    var movement: Vector3 = _velocity * delta
    move_and_collide(movement)


# ------- Functions -------
#func override_gravity(new_gravity: Vector3) -> void:
    #is_gravity_overrriden = true
    #gravity = new_gravity.normalized()

func _recompute_combined_force() -> void:
    var sum: Vector3 = Vector3.ZERO
    for force: Vector3 in _applied_forces:
        sum += force
    _curr_combined_force = sum.normalized()


func add_force(force: Vector3) -> void:
    if not force in _applied_forces:
        _applied_forces.append(force)
        _recompute_combined_force()


func remove_force(force: Vector3) -> void:
    _applied_forces.erase(force)
    _recompute_combined_force()


func clear_forces() -> void:
    _applied_forces.clear()
    _recompute_combined_force()
#func clear_gravity_override() -> void:
    #is_gravity_overrriden = false
    #gravity = Vector3.ZERO


func get_mesh() -> Mesh:
    return _mesh_instance.mesh


## Behavior to apply when the level is reset
func _level_reset_behavior() -> void:
    _curr_combined_force = Vector3.ZERO
    _applied_forces.clear()
    _velocity = Vector3.ZERO
    return
