class_name Door
extends Node3D
## A door that can be opened or closed, controlled with an [AnimationPlayer]

# ------- Exposed vars -------
@export var start_open := false


# ------- Internal vars -------
@onready var _animation_player := $AnimationPlayer as AnimationPlayer


# ------- Overriden Engine Functions -------
func _ready() -> void:
    if start_open:
        _animation_player.play(&"default_open")
    else:
        _animation_player.play(&"RESET")


# ------- Functions -------
func change_door_state(open: bool) -> void:
    if open:
        _animation_player.play(&"opening")
    else:
        _animation_player.play(&"closing")


func close_instantly() -> void:
    _animation_player.stop()
    _animation_player.play(&"RESET")
