class_name Level
extends Node3D
## Manages a single level logic to properly reset it

# ------- Exposed vars -------
@export var level_entrance: Area3D
@export var player_start: PlayerStart

@export var entrance_door: EntranceDoor
@export var exit_door: ExitDoor


# ------- Internal vars -------
var _initial_object_transforms: Dictionary[Node3D, Transform3D] = {}


# ------- Overriden Engine Functions -------
func _ready() -> void:
    level_entrance.body_entered.connect(_on_level_entrance_entered)

    var objects_to_reset: Array[Node] = []
    for group: StringName in Globals.OBJECT_GROUPS_TO_RESET:
        objects_to_reset.append_array(get_tree().get_nodes_in_group(group))
    for object in objects_to_reset:
        if object is Node3D and is_ancestor_of(object):
            _initial_object_transforms[object as Node3D] = object.transform


# ------- Functions -------
## Fully resets the current level
func reset(player: MainPlayer) -> void:
    if is_instance_valid(entrance_door):
        entrance_door.close_instantly()

    if is_instance_valid(exit_door):
        exit_door.close_instantly()

    for object in _initial_object_transforms:
        object.reset_physics_interpolation()
        object.transform = _initial_object_transforms[object]
        object.force_update_transform()

    _reset_player(player)


## Resets the player's position back to [member player_start] and resets the player camera
func _reset_player(player: MainPlayer) -> void:
    var player_transform := player_start.get_starting_transform()
    player.global_transform = player_transform

    var global_player_aabb := player.global_transform * player.physics_aabb
    var aabb_offset := player_transform.origin - global_player_aabb.position

    player.global_position += aabb_offset

    _reset_player_camera(player)


## Resets the player's camera
func _reset_player_camera(player: MainPlayer) -> void:
    player.rotation_target = player.rotation
    player.camera.rotation.x = 0
    return


## Updates the [member Globals.current_level] reference when the level is entered
func _on_level_entrance_entered(_body: Node3D) -> void:
    Globals.current_level = self
