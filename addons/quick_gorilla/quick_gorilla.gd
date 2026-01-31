@tool
extends EditorPlugin


const Constants = preload("uid://g27vfwv81e2v")


func _enable_plugin() -> void:
    add_autoload_singleton(
        Constants.PAUSE_MENU_MANAGER_AUTOLOAD,
        "res://addons/quick_gorilla/pause_menu/pause_menu_manager.tscn"
    )


func _disable_plugin() -> void:
    remove_autoload_singleton(Constants.PAUSE_MENU_MANAGER_AUTOLOAD)


func _enter_tree() -> void:
    if not ProjectSettings.has_setting(Constants.PAUSE_MENU_SCENE_SETTING):
        ProjectSettings.set_setting(Constants.PAUSE_MENU_SCENE_SETTING, "")

    var pause_menu_scene_setting_info := {
        name = Constants.PAUSE_MENU_SCENE_SETTING,
        type = TYPE_STRING,
        hint = PROPERTY_HINT_FILE,
        hint_string = "*.tscn,*.scn,*.res"
    }
    ProjectSettings.add_property_info(pause_menu_scene_setting_info)
    ProjectSettings.set_initial_value(Constants.PAUSE_MENU_SCENE_SETTING, "")


func _exit_tree() -> void:
    pass
