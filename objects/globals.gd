extends Node

## Emitted when the level is reset
signal on_level_reset()

## Number of available masks in the game
const MASK_NUM: int = 4
## Object groups that should be reset when the level is
const OBJECT_GROUPS_TO_RESET: Array[StringName] = [
    &"affected_objects"
]

## Shape a [GravityCube] can have, and a [CubeSwitch] can expect
enum GCUBE_TYPE {
    SQUARE,
    TRIANGLE,
    CIRCLE,
}

## Ref to the current [MainPlayer] node
var main_player: MainPlayer = null
## Ref to the current [Level] node
var current_level: Level = null


func reset_level() -> void:
    if not is_instance_valid(main_player):
        return

    if not is_instance_valid(current_level):
        return

    current_level.reset(main_player)
    on_level_reset.emit()
