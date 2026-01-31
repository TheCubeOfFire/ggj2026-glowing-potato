class_name EntranceDoor
extends CSGBox3D


var _is_in_threshold := false
var _is_inside_door := false

var _is_closed := false


@onready var _door := $Door as Door


func _on_threshold_entered(_body: Node3D) -> void:
    _is_in_threshold = true


func _on_threshold_exited(_body: Node3D) -> void:
    _is_in_threshold = false


func _on_inside_entered(_body: Node3D) -> void:
    _is_inside_door = true


func _on_inside_exited(_body: Node3D) -> void:
    if not _is_in_threshold and _is_inside_door and not _is_closed:
        _is_closed = true
        _door.change_door_state(false)

    _is_inside_door = false
