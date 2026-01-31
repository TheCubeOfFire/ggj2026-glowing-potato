class_name Door
extends Node3D


@export var start_open := false


@onready var _animation_player := $AnimationPlayer as AnimationPlayer


func _ready() -> void:
    if start_open:
        _animation_player.play(&"default_open")
    else:
        _animation_player.play(&"RESET")


func change_door_state(open: bool) -> void:
    if open:
        _animation_player.play(&"opening")
    else:
        _animation_player.play(&"closing")
