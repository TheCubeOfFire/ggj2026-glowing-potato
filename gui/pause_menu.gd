class_name PauseMenu
extends QuickGorillaPauseMenu


# ------- Functions -------
func _on_resume_pressed() -> void:
    _recapture_mouse()


func _on_reset_button_pressed() -> void:
    queue_free()
    Globals.reset_level.call_deferred()
    _recapture_mouse()


func _on_main_menu_pressed() -> void:
    Globals.main_player = null
    Globals.current_level = null


func _recapture_mouse() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    if is_instance_valid(Globals.main_player):
        Globals.main_player.mouse_captured = true
