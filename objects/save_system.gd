extends Node

signal on_option_edited(section: String, option: String, value: Variant)

#region settings variables
const OPTIONS_FILE_PATH: StringName = &"user://amg_options.cfg"

const VERSION_PATH: String = "version"

const SECTION_GAMEPLAY: String = "gameplay"
const SETTING_GP_CAMERA_INVERT_Y: String = "camera_invert_y"
const SETTING_GP_MOUSE_SENSITIVITY: String = "mouse_sensitivity"
const SETTING_GP_GAMEPAD_SENSITIVITY: String = "gamepad_sensitivity"

const SECTION_AUDIO: String = "audio"
const SETTING_AD_MUSIC_VOLUME: String = "music_volume"
const SETTING_AD_SFX_VOLUME: String = "sfx_volume"

var _config_data: Dictionary[String, Dictionary] = {}
var _config: ConfigFile = ConfigFile.new()

@onready var options_version: int = 0
#endregion


# ------- Overriden Engine Functions -------
func _ready() -> void:
    var err: Error = request_config_load()
    if err != OK:
        _load_default_config()
    return


# ------- Functions -------
#region private config management
func _load_default_config() -> void:
    _config.set_value(VERSION_PATH, VERSION_PATH, options_version)

    _config.set_value(SECTION_GAMEPLAY, SETTING_GP_CAMERA_INVERT_Y, false)
    _config.set_value(SECTION_GAMEPLAY, SETTING_GP_MOUSE_SENSITIVITY, 700)
    _config.set_value(SECTION_GAMEPLAY, SETTING_GP_GAMEPAD_SENSITIVITY, 0.075)

    _config.set_value(SECTION_AUDIO, SETTING_AD_MUSIC_VOLUME, 1.0)
    _config.set_value(SECTION_AUDIO, SETTING_AD_SFX_VOLUME, 1.0)

    _pull_config()
    return


func _push_config() -> void:
    _config.set_value(VERSION_PATH, VERSION_PATH, options_version)
    for section: StringName in _config_data:
        for setting: String in _config_data[section]:
            _config.set_value(section, setting, _config_data[section][setting])
    return


func _pull_config() -> void:
    for section: StringName in _config.get_sections():
        if section == VERSION_PATH:
            var saved_options_version: int = _config.get_value(VERSION_PATH, VERSION_PATH)
            if options_version < saved_options_version:
                push_warning("Attempting to load options from a more recent version!")
            continue

        if section not in _config_data.keys():
            _config_data[section] = {}

        for setting: String in _config.get_section_keys(section):
            _config_data[section][setting] = _config.get_value(section, setting)

    return
#endregion

#region public save load functions
func request_config_save() -> Error:
    _push_config()

    var time_str: String = Time.get_time_string_from_system()
    print_rich("[b][lb]SaveSystem[rb][/b] (",time_str,") - Attempting to save settings")
    var err: Error = _config.save(OPTIONS_FILE_PATH)
    return err


func request_config_load() -> Error:
    var time_str: String = Time.get_time_string_from_system()
    print_rich("[b][lb]SaveSystem[rb][/b] (",time_str,") - Attempting to load settings")
    var err: Error = _config.load(OPTIONS_FILE_PATH)

    if err == OK:
        _pull_config()

    return err


func get_option_value(section: String, option: String) -> Variant:
    if section not in _config_data:
        push_error("Unknown options section: \"",section,"\"")
        return null

    if option not in _config_data[section]:
        push_error("Unknown option \"",option,"\" in section \"",section,"\"")
        return null

    return _config_data[section][option]


func set_option_value(section: String, option: String, value: Variant) -> bool:
    if section not in _config_data:
        push_error("Unknown options section: \"",section,"\"")
        return false

    if option not in _config_data[section]:
        push_error("Unknown option \"",option,"\" in section \"",section,"\"")
        return false

    _config_data[section][option] = value
    on_option_edited.emit(section, option, value)
    return true
#endregion
