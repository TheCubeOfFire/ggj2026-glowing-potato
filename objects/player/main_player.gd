extends CharacterBody3D

# ------- Exposed vars -------
## Movement speed for the player
@export var movement_speed: float = 0.0

# ------- Internal vars -------
@onready var camera: Camera3D = $Camera3D

var movement_velocity: Vector3

# ------- Overriden Engine Functions -------
func _process(delta: float) -> void:
    handle_input(delta)

    move_and_slide()
    return


# ------- Other Functions -------
func handle_input(_delta: float) -> void:
    var input_vector: Vector2 = Input.get_vector(&"move_backward", &"move_forward", &"move_left", &"move_right")
    movement_velocity = Vector3(input_vector.x, 0, input_vector.y) * movement_speed
    velocity = movement_velocity
    return
