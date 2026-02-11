class_name Settings
extends Control

# ------- Internal vars -------
@onready var cb_invert_camera: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/CB_InvertCameraY
@onready var hs_mouse_sensitivity: HSlider = $PanelContainer/MarginContainer/VBoxContainer/HS_MouseSensitivity
@onready var hs_gamepad_sensitivity: HSlider = $PanelContainer/MarginContainer/VBoxContainer/HS_GamepadSensitivity
@onready var hs_music_volume: HSlider = $PanelContainer/MarginContainer/VBoxContainer/HS_MusicVolume
@onready var hs_sfx_volmue: HSlider = $PanelContainer/MarginContainer/VBoxContainer/HS_SFXVolume


# ------- Overriden Engine Functions -------
func _ready() -> void:
    _initialize_ui_values()
    return


# ------- Functions -------
func _initialize_ui_values() -> void:
    cb_invert_camera.button_pressed = SaveSystem.get_option_value(SaveSystem.SECTION_GAMEPLAY, SaveSystem.SETTING_GP_CAMERA_INVERT_Y)
    hs_mouse_sensitivity.value = SaveSystem.get_option_value(SaveSystem.SECTION_GAMEPLAY, SaveSystem.SETTING_GP_MOUSE_SENSITIVITY)
    hs_gamepad_sensitivity.value = SaveSystem.get_option_value(SaveSystem.SECTION_GAMEPLAY, SaveSystem.SETTING_GP_GAMEPAD_SENSITIVITY)
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


func _on_hs_music_volume_value_changed(value: float) -> void:
    SaveSystem.set_option_value(SaveSystem.SECTION_AUDIO, SaveSystem.SETTING_AD_MUSIC_VOLUME, value)
    return


func _on_hs_sfx_volume_value_changed(value: float) -> void:
    SaveSystem.set_option_value(SaveSystem.SECTION_AUDIO, SaveSystem.SETTING_AD_SFX_VOLUME, value)
    return


func _on_back_pressed() -> void:
    SaveSystem.request_config_save()
    queue_free()
    return
