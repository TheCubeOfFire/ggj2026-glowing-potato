extends Node

signal on_level_reset()

const MASK_NUM: int = 4
const OBJECT_GROUPS_TO_RESET: Array[StringName] = [
    &"affected_objects"
]

enum GCUBE_TYPE {
    SQUARE,
    TRIANGLE,
    CIRCLE,
}


var main_player: MainPlayer = null
var current_level: Level = null


func reset_level() -> void:
    if not is_instance_valid(main_player):
        return

    if not is_instance_valid(current_level):
        return

    current_level.reset(main_player)
    on_level_reset.emit()
