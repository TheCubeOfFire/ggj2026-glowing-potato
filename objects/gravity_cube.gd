class_name GravityCube
extends AnimatableBody3D

# ------- Internal vars -------
@onready var default_gravity_force: float = ProjectSettings.get_setting(&"physics/3d/default_gravity")

var is_gravity_overrriden: bool = false
var gravity: Vector3 = Vector3.ZERO

# ------- Overriden Engine Functions -------
func _physics_process(delta: float) -> void:
    #if Input.is_action_just_pressed(&"debug_test"):
        #if is_gravity_overrriden:
            #clear_gravity_override()
        #else:
            #override_gravity(Vector3(0,1,0))

    var movement: Vector3 = default_gravity_force * gravity * delta
    move_and_collide(movement)
    return

# ------- Functions -------
func override_gravity(new_gravity: Vector3) -> void:
    is_gravity_overrriden = true
    gravity = new_gravity.normalized()
    return

func clear_gravity_override() -> void:
    is_gravity_overrriden = false
    gravity = Vector3.ZERO
    return
