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
## Whether the cube's gravity is currently overriden
var is_gravity_overrriden: bool = false
## The current "gravity" force that is applied to this cube
var gravity: Vector3 = Vector3.ZERO


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
    var gravity_acceleration := default_gravity_force * gravity
    _velocity *= 1.0 - friction
    _velocity += gravity_acceleration * delta

    var movement: Vector3 = _velocity * delta
    move_and_collide(movement)


# ------- Functions -------
func override_gravity(new_gravity: Vector3) -> void:
    is_gravity_overrriden = true
    gravity = new_gravity.normalized()


func clear_gravity_override() -> void:
    is_gravity_overrriden = false
    gravity = Vector3.ZERO


func get_mesh() -> Mesh:
    return _mesh_instance.mesh


## Behavior to apply when the level is reset
func _level_reset_behavior() -> void:
    gravity = Vector3.ZERO
    _velocity = Vector3.ZERO
    return
