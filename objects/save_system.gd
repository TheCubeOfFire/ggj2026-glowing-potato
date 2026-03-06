extends Node

signal on_option_edited(section: String, option: String, value: Variant)

#region settings variables
const OPTIONS_FILE_PATH: StringName = &"user://amg_options.cfg"

const VERSION_PATH: String = "version"

const SECTION_GAMEPLAY: String = "gameplay"
const SETTING_GP_CAMERA_INVERT_Y: String = "camera_invert_y"
const SETTING_GP_MOUSE_SENSITIVITY: String = "mouse_sensitivity"
const SETTING_GP_GAMEPAD_SENSITIVITY: String = "gamepad_sensitivity"

const SECTION_GRAPHICS: String = "graphics"
const SETTING_GR_WINDOW_MODE: String = "window_mode"

const SECTION_AUDIO: String = "audio"
const SETTING_AD_MUSIC_VOLUME: String = "music_volume"
const SETTING_AD_SFX_VOLUME: String = "sfx_volume"

var _config: ConfigFile = ConfigFile.new()

var default_config: Dictionary[String, Dictionary] = {
    SECTION_GAMEPLAY: {
        SETTING_GP_CAMERA_INVERT_Y: false,
        SETTING_GP_MOUSE_SENSITIVITY: 1.0,
        SETTING_GP_GAMEPAD_SENSITIVITY: 1.0,
    },

    SECTION_GRAPHICS: {
        SETTING_GR_WINDOW_MODE: 1,
    },

    SECTION_AUDIO: {
        SETTING_AD_MUSIC_VOLUME: 1.0,
        SETTING_AD_SFX_VOLUME: 1.0,
    },
}
#endregion


# ------- Overriden Engine Functions -------
func _ready() -> void:
    var err: Error = request_config_load()
    if err == OK:
        var last_saved_version: int = _config.get_value(VERSION_PATH, VERSION_PATH)
        if last_saved_version < get_current_options_version():
            print("Loading settings from version ",last_saved_version," - Updating to version ", get_current_options_version())
    else:
        push_warning("Couldn't load settings: Error ", str(err)," - Applying default config")

    _complete_with_default_config()
    return


# ------- Functions -------
#region private config management
func _complete_with_default_config() -> void:
    _config.set_value(VERSION_PATH, VERSION_PATH, get_current_options_version())

    for section: String in default_config.keys():
        for setting: String in default_config[section]:
            if not _config.has_section_key(section, setting):
                _config.set_value(section, setting, default_config[section][setting])
    return
#endregion

#region public save load functions
func get_current_options_version() -> int:
    return 1

func request_config_save() -> Error:
    var time_str: String = Time.get_time_string_from_system()
    print_rich("[b][lb]SaveSystem[rb][/b] (",time_str,") - Attempting to save settings")
    var err: Error = _config.save(OPTIONS_FILE_PATH)
    return err


func request_config_load() -> Error:
    var time_str: String = Time.get_time_string_from_system()
    print_rich("[b][lb]SaveSystem[rb][/b] (",time_str,") - Attempting to load settings")
    var err: Error = _config.load(OPTIONS_FILE_PATH)
    return err


func get_option_value(section: String, option: String) -> Variant:
    if not _config.has_section(section):
        push_error("Unknown options section: \"",section,"\"")
        return null

    if not _config.has_section_key(section, option):
        push_error("Unknown option \"",option,"\" in section \"",section,"\"")
        return null

    return _config.get_value(section, option)


func set_option_value(section: String, option: String, value: Variant) -> bool:
    if not _config.has_section(section):
        push_error("Unknown options section: \"",section,"\"")
        return false

    if not _config.has_section_key(section, option):
        push_error("Unknown option \"",option,"\" in section \"",section,"\"")
        return false

    _config.set_value(section, option, value)
    on_option_edited.emit(section, option, value)
    return true
#endregion

#region settings application
func apply_graphics_setting() -> void:
    match get_option_value(SECTION_GRAPHICS, SETTING_GR_WINDOW_MODE):
        0:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
            DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
            pass
        1:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
            pass
        2:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
            pass
        _:
            pass
    return

func apply_audio_settings() -> void:
    AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(&"Music"), get_option_value(SECTION_AUDIO,SETTING_AD_MUSIC_VOLUME))
    AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(&"SFX"), get_option_value(SECTION_AUDIO, SETTING_AD_SFX_VOLUME))
    return
#endregion
