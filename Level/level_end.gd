class_name EndLevel
extends Node3D
const MAIN_MENU = preload("res://gui/main_menu.tscn")

func _on_pedestal_on_mask_claimed() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    get_tree().change_scene_to_file("res://gui/main_menu.tscn")
