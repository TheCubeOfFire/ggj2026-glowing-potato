class_name Door
extends CSGBox3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var switches: Array[CubeSwitch]
var switch_states: Array[bool]
var door_open: bool

func _ready() -> void:
    for switch_index in switches.size():
        switches[switch_index].on_activated.connect(on_state_changed.bind(switch_index, true))
        switches[switch_index].on_deactivated.connect(on_state_changed.bind(switch_index, false))
    switch_states.resize(switches.size())
    switch_states.fill(false)

func on_state_changed(switch_index: int, state: bool) -> void:
    switch_states[switch_index] = state
    if not switch_states.has(false):
        animation_player.play(&"door")
        door_open = true
    elif door_open:
        animation_player.play_backwards(&"door")
        door_open = false
