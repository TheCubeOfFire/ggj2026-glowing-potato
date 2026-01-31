extends CharacterBody3D

# ------- Exposed vars -------
## Movement speed for the player
@export var movement_speed: float = 0.0

@export var mask_handling: MaskHandling

@export var mask_physical_effect_manager: MaskPhysicalEffectManager

# ------- Internal vars -------
@onready var camera: Camera3D = $Camera3D
@onready var pedestal_raycast: RayCast3D = $Camera3D/PedestalRaycast
@onready var gravity_force: float = ProjectSettings.get_setting(&"physics/3d/default_gravity")
@onready var gravity_vector: Vector3 = ProjectSettings.get_setting(&"physics/3d/default_gravity_vector")

var targeted_pedestal: Pedestal = null
var unlocked_masks: Array[bool] = [false, false, false, false]

var movement_velocity: Vector3
var rotation_target: Vector3

var mouse_sensitivity: int = 700
var gamepad_sensitivity: float = 0.075
var mouse_captured: bool = true
var input_mouse: Vector2 = Vector2.ZERO

# ------- Overriden Engine Functions -------
func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    return

func _physics_process(delta: float) -> void:
    handle_movement(delta)
    handle_gravity(delta)

    handle_mouse_input(delta)
    handle_rotation_input(delta)

    move_and_slide()

    handle_mask_input()
    handle_pedestal_detection()
    handle_interact_input()
    return

func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and mouse_captured:
        var iemm := event as InputEventMouseMotion
        input_mouse = iemm.screen_relative / mouse_sensitivity
        handle_rotation(iemm.screen_relative.x, iemm.screen_relative.y, false)
    return

# ------- Other Functions -------
func handle_movement(_delta: float) -> void:
    var input_vector: Vector2 = Input.get_vector(&"move_backward", &"move_forward", &"move_left", &"move_right")
    movement_velocity = Vector3(input_vector.x, 0, input_vector.y) * movement_speed
    velocity = transform.basis * movement_velocity
    return

func handle_gravity(_delta: float) -> void:
    velocity += gravity_vector * gravity_force
    return

func handle_mouse_input(_delta: float) -> void:
    # Mouse capture
    if Input.is_action_just_pressed(&"mouse_capture"):
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
        mouse_captured = true

    if Input.is_action_just_pressed(&"mouse_capture_exit"):
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        mouse_captured = false
        input_mouse = Vector2.ZERO
    return

func handle_rotation_input(_delta: float) -> void:
    var invert_y_rotation: bool = false
    var rotation_input := Input.get_vector(&"camera_left", &"camera_right",\
                                            &"camera_down" if invert_y_rotation else &"camera_up",\
                                            &"camera_up" if invert_y_rotation else &"camera_down")
    if rotation_input:
        handle_rotation(rotation_input.x, rotation_input.y, true, _delta)
    return

func handle_rotation(x_rot: float, y_rot: float, is_controller: bool, _delta: float = 0.0) -> void:
    if is_controller:
        rotation_target += Vector3(-y_rot, -x_rot, 0).limit_length(1.0) * gamepad_sensitivity
    else:
        rotation_target += (Vector3(-y_rot, -x_rot, 0) / mouse_sensitivity)

    rotation_target.x = clamp(rotation_target.x, deg_to_rad(-90), deg_to_rad(90))
    camera.rotation.x = rotation_target.x
    rotation.y = rotation_target.y
    return

#region mask toggling
func handle_mask_input() -> void:
    if Input.is_action_just_pressed(&"toggle_mask0") and unlocked_masks[0]:
        toggle_mask(0)
        pass
    if Input.is_action_just_pressed(&"toggle_mask1") and unlocked_masks[1]:
        toggle_mask(1)
        pass
    if Input.is_action_just_pressed(&"toggle_mask2") and unlocked_masks[2]:
        toggle_mask(2)
        pass
    if Input.is_action_just_pressed(&"toggle_mask3") and unlocked_masks[3]:
        toggle_mask(3)
        pass
    return

func toggle_mask(mask_index: int) -> void:
    assert(0 <= mask_index and mask_index <= 3)
    mask_handling.toggle_mask_visual(mask_index)
    mask_physical_effect_manager.toggle_mask_effect(mask_index)
    return
#endregion

#region pedetals
func handle_pedestal_detection():
    if pedestal_raycast.is_colliding():
        var static_body_node: Node3D = pedestal_raycast.get_collider() as Node3D
        targeted_pedestal = static_body_node.get_parent() as Pedestal
    else:
        targeted_pedestal = null
    return


func handle_interact_input():
    if Input.is_action_just_pressed(&"interact") and targeted_pedestal:
        unlock_mask(targeted_pedestal.given_mask)
        targeted_pedestal.claim_mask()
    return


func unlock_mask(mask_index: int) -> void:
    assert(0 <= mask_index and mask_index <= 3)
    unlocked_masks[mask_index] = true
    return
#endregion
