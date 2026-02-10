class_name Settings
extends Control


func _on_cb_invert_camera_y_toggled(toggled_on: bool) -> void:
    SaveSystem.set_option_value(SaveSystem.SECTION_GAMEPLAY, SaveSystem.SETTING_GP_CAMERA_INVERT_Y, toggled_on)
    return


func _on_hs_mouse_sensitivity_value_changed(value: float) -> void:
    SaveSystem.set_option_value(SaveSystem.SECTION_GAMEPLAY, SaveSystem.SETTING_GP_MOUSE_SENSITIVITY, value)
    return


func _on_hs_gamepad_sensitivity_value_changed(value: float) -> void:
    SaveSystem.set_option_value(SaveSystem.SECTION_GAMEPLAY, SaveSystem.SETTING_GP_GAMEPAD_SENSITIVITY, value)
    return


func _on_hs_music_volume_value_changed(value: float) -> void:
    SaveSystem.set_option_value(SaveSystem.SECTION_AUDIO, SaveSystem.SETTING_AD_MUSIC_VOLUME, value)
    return


func _on_hs_sfx_volume_value_changed(value: float) -> void:
    SaveSystem.set_option_value(SaveSystem.SECTION_AUDIO, SaveSystem.SETTING_AD_SFX_VOLUME, value)
    return


func _on_back_pressed() -> void:
    queue_free()
    return
