extends Control


# Scene which will be instantiated to show the pause menu
var _pause_menu_scene: PackedScene = null
# Current pause menu. Null if the pause menu is currently not shown
var _pause_menu: Control = null


func _ready() -> void:
    _load_pause_menu()


## Spawn the pause menu
func show_pause_menu() -> void:
    if not is_instance_valid(_pause_menu):
        if not is_instance_valid(_pause_menu_scene):
            push_error("Pause menu requested to show, "
                + "but its scene is not valid")
            return

        _pause_menu = _pause_menu_scene.instantiate()
        _pause_menu.tree_exited.connect(_on_pause_menu_tree_exited)
        add_child(_pause_menu)


func _load_pause_menu() -> void:
    if not ProjectSettings.has_setting(
        QuickGorillaConstants.PAUSE_MENU_SCENE_SETTING
    ):
        return

    var pause_menu_scene_path := ProjectSettings.get_setting_with_override(
        QuickGorillaConstants.PAUSE_MENU_SCENE_SETTING
    ) as String

    if pause_menu_scene_path.is_empty():
        return

    if not ResourceLoader.exists(pause_menu_scene_path):
        push_warning("Pause menu is configured, but is not valid!")
        return

    _pause_menu_scene = load(pause_menu_scene_path)


func _on_pause_menu_tree_exited() -> void:
    _pause_menu = null
