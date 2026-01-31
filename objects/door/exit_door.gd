class_name ExitDoor
extends CSGBox3D


@export var switches: Array[CubeSwitch]


var switch_states: Array[bool]


@onready var _door := $Door as Door


func _ready() -> void:
    for switch_index in switches.size():
        switches[switch_index].on_activated.connect(on_state_changed.bind(switch_index, true))
        switches[switch_index].on_deactivated.connect(on_state_changed.bind(switch_index, false))
    switch_states.resize(switches.size())
    switch_states.fill(false)


func on_state_changed(switch_index: int, is_switch_active: bool) -> void:
    switch_states[switch_index] = is_switch_active
    if switch_states.has(false):
        _door.change_door_state(false)
    elif is_switch_active:
        _door.change_door_state(true)
