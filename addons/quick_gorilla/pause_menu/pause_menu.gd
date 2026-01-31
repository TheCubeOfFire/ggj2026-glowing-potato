## Base class for a pause menu
class_name QuickGorillaPauseMenu
extends Control


## Button which simply closes the pause menu
@export var resume_button: BaseButton
## Button which closes the pause menu and go back to the main menu
@export var main_menu_button: BaseButton

## Path to the scene used as the main menu
@export_file("*.tscn", "*.scn", "*.res") var main_menu_scene_path: String


func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS

    get_tree().paused = true

    var connect_button := func (button: StringName, callback: Callable):
        if get(button) != null:
            QuickGorillaUtilities.safe_connect_button_pressed(
                self, button, callback)
    connect_button.call(&"resume_button", _on_resume_button_pressed)
    connect_button.call(&"main_menu_button", _on_main_menu_button_pressed)

    if is_instance_valid(resume_button):
        resume_button.grab_focus.call_deferred()


func _exit_tree() -> void:
    get_tree().paused = false


func _on_resume_button_pressed() -> void:
    queue_free()


func _on_main_menu_button_pressed() -> void:
    if main_menu_scene_path.is_empty():
        push_warning("Can't return to main menu: main menu scene is not set up!")
        return

    if not ResourceLoader.exists(main_menu_scene_path):
        push_warning("Can't return to main menu: main menu scene is not valid!")
        return

    queue_free()
    get_tree().change_scene_to_file(main_menu_scene_path)
