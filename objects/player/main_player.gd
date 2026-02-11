class_name MainPlayer
extends CharacterBody3D


# ------- Exposed vars -------
## Movement speed for the player
@export var movement_speed: float = 0.0

@export var mask_handling: MaskHandling

@export var mask_physical_effect_manager: MaskPhysicalEffectManager

# ------- Internal vars -------
@onready var camera: Camera3D = $Camera3D
@onready var pedestal_raycast: RayCast3D = $Camera3D/PedestalRaycast
@onready var hud: Hud = $'Camera3D/Hud'
@onready var gravity_force: float = ProjectSettings.get_setting(&"physics/3d/default_gravity")
@onready var gravity_vector: Vector3 = ProjectSettings.get_setting(&"physics/3d/default_gravity_vector")


var physics_aabb: AABB:
    get:
        return _physics_aabb

var targeted_pedestal: Pedestal = null
var unlocked_masks: Array[bool] = [false, false, false, false]

var movement_velocity: Vector3
@onready var rotation_target: Vector3 = rotation

var mouse_sensitivity: float
var mouse_sensitivity_base: int = 500
var gamepad_sensitivity: float
var gamepad_sensitivity_base: float = 0.075
var mouse_captured: bool = true
var input_mouse: Vector2 = Vector2.ZERO
var invert_camera_y: bool = false

var _pause_pressed := false

var _physics_aabb := AABB()

var seen_unique_tips: Dictionary[StringName,bool] = {}


# ------- Overriden Engine Functions -------
func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    _physics_aabb = _compute_aabb(_get_shapes())
    Globals.main_player = self
    Globals.on_level_reset.connect(_on_reset_called)
    apply_settings()


func _physics_process(delta: float) -> void:
    handle_movement(delta)
    handle_gravity(delta)

    handle_mouse_input(delta)
    handle_rotation_input(delta)

    move_and_slide()

    handle_mask_input()
    handle_pedestal_detection()
    handle_interact_input()

    if OS.is_debug_build():
        handle_debug_input()
    return

func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and mouse_captured:
        var iemm := event as InputEventMouseMotion
        input_mouse = iemm.screen_relative
        handle_rotation(input_mouse.x, input_mouse.y, 0.0)

    if event.is_action_pressed(&"pause"):
        _pause_pressed = true

    if event.is_action_released(&"pause") and _pause_pressed:
        _pause_pressed = false
        QuickGorilla_PauseMenuManager.show_pause_menu()
        get_viewport().set_input_as_handled()


# ------- Other Functions -------
func apply_settings() -> void:
    invert_camera_y = SaveSystem.get_option_value(SaveSystem.SECTION_GAMEPLAY, SaveSystem.SETTING_GP_CAMERA_INVERT_Y)
    mouse_sensitivity = SaveSystem.get_option_value(SaveSystem.SECTION_GAMEPLAY, SaveSystem.SETTING_GP_MOUSE_SENSITIVITY)
    gamepad_sensitivity = SaveSystem.get_option_value(SaveSystem.SECTION_GAMEPLAY, SaveSystem.SETTING_GP_GAMEPAD_SENSITIVITY)
    return

func handle_movement(_delta: float) -> void:
    var input_vector: Vector2 = Input.get_vector(&"move_backward", &"move_forward", &"move_left", &"move_right")
    movement_velocity = Vector3(input_vector.x, 0, input_vector.y) * movement_speed
    velocity = transform.basis * movement_velocity
    return

func handle_gravity(_delta: float) -> void:
    velocity += gravity_vector * gravity_force
    return


#region rotation
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
    var rotation_input := Input.get_vector(&"camera_left", &"camera_right", &"camera_up", &"camera_down")
    if rotation_input:
        handle_rotation(rotation_input.x, rotation_input.y, true, _delta)
    return


func handle_rotation(x_rot: float, y_rot: float, is_controller: bool, _delta: float = 0.0) -> void:
    if invert_camera_y:
        y_rot = -y_rot

    if is_controller:
        rotation_target += Vector3(-y_rot, -x_rot, 0).limit_length(1.0) * gamepad_sensitivity_base * gamepad_sensitivity
    else:
        rotation_target += (Vector3(-y_rot, -x_rot, 0) / mouse_sensitivity_base) * mouse_sensitivity

    rotation_target.x = clamp(rotation_target.x, deg_to_rad(-90), deg_to_rad(90))
    camera.rotation.x = rotation_target.x
    rotation.y = rotation_target.y
    return
#endregion

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

#region pedestals
func handle_pedestal_detection():
    if pedestal_raycast.is_colliding():
        var static_body_node: Node3D = pedestal_raycast.get_collider() as Node3D
        if static_body_node:
            targeted_pedestal = static_body_node.get_parent() as Pedestal
            hud.set_interact_prompt_visibility(targeted_pedestal.has_mask)
    else:
        targeted_pedestal = null
        hud.set_interact_prompt_visibility(false)
    return


func handle_interact_input():
    if Input.is_action_just_pressed(&"interact") and targeted_pedestal and targeted_pedestal.has_mask:
        unlock_mask(targeted_pedestal.given_mask)
        targeted_pedestal.claim_mask()
    return


func unlock_mask(mask_index: int) -> void:
    assert(0 <= mask_index and mask_index <= 3)
    unlocked_masks[mask_index] = true
    hud.set_mask_container_visibility(mask_index, true)
    return
#endregion

#region debug input
func handle_debug_input() -> void:
    if Input.is_action_just_pressed(&"debug_unlock_mask0"):
        unlock_mask(0)
    if Input.is_action_just_pressed(&"debug_unlock_mask1"):
        unlock_mask(1)
    if Input.is_action_just_pressed(&"debug_unlock_mask2"):
        unlock_mask(2)
    if Input.is_action_just_pressed(&"debug_unlock_mask3"):
        unlock_mask(3)
    return
#endregion

#region tips
func display_tip(tip_key) -> void:
    if seen_unique_tips.get(tip_key, false):
        return
    hud.display_tip(tip_key)
    seen_unique_tips.set(tip_key, true)
    return

func clear_tips(fade_out: bool) -> void:
    hud.clear_tips(fade_out)
    return

func _on_reset_called() -> void:
    clear_tips(false)
    return
#endregion

#region physics_aabb
func _get_shapes() -> Dictionary[int, ShapeData]:
    var shape_owner_ids := get_shape_owners()
    var shapes: Dictionary[int, ShapeData] = {}
    for owner_id in shape_owner_ids:
        var shape_count := shape_owner_get_shape_count(owner_id)
        var owner_transform := shape_owner_get_transform(owner_id)
        for shape_id in shape_count:
            var shape_index := shape_owner_get_shape_index(owner_id, shape_id)
            var shape := shape_owner_get_shape(owner_id, shape_id)
            shapes[shape_index] = ShapeData.new(owner_id, shape, owner_transform)
    return shapes


func _compute_aabb(shapes: Dictionary[int, ShapeData]) -> AABB:
    var result := AABB()
    for shape_index in shapes:
        var shape_data := shapes[shape_index]
        var shape := shape_data.shape
        var shape_transform := shape_data.transform

        var shape_aabb := shape_transform * _compute_aabb_of_shape(shape)
        if result.size.is_zero_approx():
            result = shape_aabb
        else:
            result = result.merge(shape_aabb)

    return result


func _compute_aabb_of_shape(shape: Shape3D) -> AABB:
    if is_instance_of(shape, BoxShape3D):
        return _compute_aabb_of_box(shape as BoxShape3D)
    if is_instance_of(shape, SphereShape3D):
        return _compute_aabb_of_ball(shape as SphereShape3D)
    if is_instance_of(shape, CylinderShape3D):
        return _compute_aabb_of_cylinder(shape as CylinderShape3D)
    if is_instance_of(shape, CapsuleShape3D):
        return _compute_aabb_of_capsule(shape as CapsuleShape3D)
    if is_instance_of(shape, ConvexPolygonShape3D):
        return _compute_aabb_of_convex_polyhedron(shape as ConvexPolygonShape3D)

    return AABB() # TODO


func _compute_aabb_of_box(box_shape: BoxShape3D) -> AABB:
    return AABB(-0.5 * box_shape.size, box_shape.size)


func _compute_aabb_of_ball(sphere_shape: SphereShape3D) -> AABB:
    var radius := sphere_shape.radius
    return AABB(-radius * Vector3.ONE, 2.0 * radius * Vector3.ONE)


func _compute_aabb_of_cylinder(cylinder_shape: CylinderShape3D) -> AABB:
    var radius := cylinder_shape.radius
    var half_height := 0.5 * cylinder_shape.height
    var half_size := Vector3(radius, half_height, radius)
    return AABB(-half_size, 2.0 * half_size)


func _compute_aabb_of_capsule(capsule_shape: CapsuleShape3D) -> AABB:
    var radius := capsule_shape.radius
    var half_height := 0.5 * capsule_shape.height
    var half_size := Vector3(radius, half_height, radius)
    return AABB(-half_size, 2.0 * half_size)


func _compute_aabb_of_convex_polyhedron(convex_shape: ConvexPolygonShape3D) -> AABB:
    var points := convex_shape.points
    if points.is_empty():
        return AABB()

    var min_point := points[0]
    var max_point := points[0]
    for point_index in range(1, points.size()):
        var point := points[point_index]
        min_point = point.min(min_point)
        max_point = point.max(max_point)

    return AABB(min_point, max_point - min_point)
#endregion


class ShapeData extends RefCounted:
    var owner_id: int
    var shape: Shape3D
    var transform: Transform3D


    func _init(p_owner_id: int, p_shape: Shape3D, p_transform: Transform3D) -> void:
        owner_id = p_owner_id
        shape = p_shape
        transform = p_transform
