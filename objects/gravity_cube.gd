class_name GravityCube
extends AnimatableBody3D

# ------- Exposed vars -------
@export var cube_type := Globals.GCUBE_TYPE.SQUARE


# ------- Internal vars -------
var is_gravity_overrriden: bool = false
var gravity: Vector3 = Vector3.ZERO


@onready var default_gravity_force: float = ProjectSettings.get_setting(&"physics/3d/default_gravity")

@onready var _mesh_instance := $MeshInstance3D as MeshInstance3D


# ------- Overriden Engine Functions -------
func _physics_process(delta: float) -> void:
    #if Input.is_action_just_pressed(&"debug_test"):
        #if is_gravity_overrriden:
            #clear_gravity_override()
        #else:
            #override_gravity(Vector3(0,1,0))

    var movement: Vector3 = default_gravity_force * gravity * delta
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
