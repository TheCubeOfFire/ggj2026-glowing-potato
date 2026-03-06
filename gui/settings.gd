class_name Settings
extends Control

# ------- Internal vars -------
@onready var cb_invert_camera: CheckBox = %CB_InvertCameraY
@onready var hs_mouse_sensitivity: HSlider = %HS_MouseSensitivity
@onready var hs_gamepad_sensitivity: HSlider = %HS_GamepadSensitivity

@onready var ob_window_mode: OptionButton = %OB_WindowMode

@onready var hs_music_volume: HSlider = %HS_MusicVolume
@onready var hs_sfx_volmue: HSlider = %HS_SFXVolume


# ------- Overriden Engine Functions -------
func _ready() -> void:
    _initialize_ui_values()
    cb_invert_camera.grab_focus()
    return


# ------- Functions -------
func _initialize_ui_values() -> void:
    cb_invert_camera.button_pressed = SaveSystem.get_option_value(SaveSystem.SECTION_GAMEPLAY, SaveSystem.SETTING_GP_CAMERA_INVERT_Y)
    hs_mouse_sensitivity.value = SaveSystem.get_option_value(SaveSystem.SECTION_GAMEPLAY, SaveSystem.SETTING_GP_MOUSE_SENSITIVITY)
    hs_gamepad_sensitivity.value = SaveSystem.get_option_value(SaveSystem.SECTION_GAMEPLAY, SaveSystem.SETTING_GP_GAMEPAD_SENSITIVITY)

    ob_window_mode.select(SaveSystem.get_option_value(SaveSystem.SECTION_GRAPHICS, SaveSystem.SETTING_GR_WINDOW_MODE))

    hs_music_volume.value = SaveSystem.get_option_value(SaveSystem.SECTION_AUDIO, SaveSystem.SETTING_AD_MUSIC_VOLUME)
    hs_sfx_volmue.value = SaveSystem.get_option_value(SaveSystem.SECTION_AUDIO, SaveSystem.SETTING_AD_SFX_VOLUME)
    return


func _on_cb_invert_camera_y_toggled(toggled_on: bool) -> void:
    SaveSystem.set_option_value(SaveSystem.SECTION_GAMEPLAY, SaveSystem.SETTING_GP_CAMERA_INVERT_Y, toggled_on)
    return


func _on_hs_mouse_sensitivity_value_changed(value: float) -> void:
    SaveSystem.set_option_value(SaveSystem.SECTION_GAMEPLAY, SaveSystem.SETTING_GP_MOUSE_SENSITIVITY, value)
    return


func _on_hs_gamepad_sensitivity_value_changed(value: float) -> void:
    SaveSystem.set_option_value(SaveSystem.SECTION_GAMEPLAY, SaveSystem.SETTING_GP_GAMEPAD_SENSITIVITY, value)
    return


func _on_ob_window_mode_item_selected(index: int) -> void:
    SaveSystem.set_option_value(SaveSystem.SECTION_GRAPHICS, SaveSystem.SETTING_GR_WINDOW_MODE, index)
    SaveSystem.apply_graphics_setting()
    return


func _on_hs_music_volume_value_changed(value: float) -> void:
    SaveSystem.set_option_value(SaveSystem.SECTION_AUDIO, SaveSystem.SETTING_AD_MUSIC_VOLUME, value)
    SaveSystem.apply_audio_settings()
    return


func _on_hs_sfx_volume_value_changed(value: float) -> void:
    SaveSystem.set_option_value(SaveSystem.SECTION_AUDIO, SaveSystem.SETTING_AD_SFX_VOLUME, value)
    SaveSystem.apply_audio_settings()
    return


func _on_back_pressed() -> void:
    SaveSystem.request_config_save()
    queue_free()
    return
