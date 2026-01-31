## Abstract base class for main menu
##
## All buttons are optional, so some can be left null if not needed in the
## current game.
@abstract
class_name QuickGorillaMainMenu
extends Control


## Button which transitions to entry_scene_path when clicked
@export var play_button: BaseButton
## Button opening the options menu
@export var options_button: BaseButton
## Button opening the credits menu
@export var credits_button: BaseButton
## Button which closes the game. Hidden on non-desktop platforms.
@export var quit_button: BaseButton

## Base control of all submenus.
##
## Will be hidden by default and shown when a submenu is spawned.
## Can be the same as submenu_container, but using a different node allows
## creating backgrounds or borders for the submenus
@export var submenu_decoration: Control
## Control where the submenu controls will be added
@export var submenu_container: Control

## Control to spawn as the options menu
@export var options_widget: PackedScene
## Control to spawn as the credits menu
@export var credits_widget: PackedScene

## Path to the first scene of the game which will be transitionned to when
## play_button is clicked
@export_file("*.tscn", "*.scn", "*.res") var entry_scene_path: String


# The widget previously focused before going into a submenu
var _previously_focused_control: Control = null


func _ready() -> void:
    var connect_button := func (button: StringName, callback: Callable):
        if get(button) != null:
            QuickGorillaUtilities.safe_connect_button_pressed(
                self, button, callback)
    connect_button.call(&"play_button", _on_play_button_pressed)
    connect_button.call(&"options_button", _on_options_button_pressed)
    connect_button.call(&"credits_button", _on_credits_button_pressed)
    connect_button.call(&"quit_button", _on_quit_button_pressed)

    if is_instance_valid(quit_button) and not OS.has_feature("pc"):
        quit_button.hide()

    if is_instance_valid(submenu_decoration):
        if submenu_decoration.process_mode == Node.PROCESS_MODE_INHERIT:
            submenu_decoration.process_mode = Node.PROCESS_MODE_PAUSABLE
        submenu_decoration.hide()

    if is_instance_valid(submenu_container):
        if submenu_container.process_mode == Node.PROCESS_MODE_INHERIT:
            submenu_container.process_mode = Node.PROCESS_MODE_PAUSABLE
        submenu_container.hide()

    var control_to_focus := _get_default_focused_control()
    if is_instance_valid(control_to_focus):
        control_to_focus.grab_focus.call_deferred()


## Get the control to be focused when the main menu shows
@abstract func _get_default_focused_control() -> Control


func _on_play_button_pressed() -> void:
    if entry_scene_path.is_empty():
        push_warning("Can't play: entry scene is not set up!")
        return

    if not ResourceLoader.exists(entry_scene_path):
        push_warning("Can't play: entry scene is not valid!")
        return

    get_tree().change_scene_to_file(entry_scene_path)


func _on_options_button_pressed() -> void:
    _add_submenu_widget(&"options_widget")


func _on_credits_button_pressed() -> void:
    _add_submenu_widget(&"credits_widget")


func _on_quit_button_pressed() -> void:
    get_tree().quit()


func _add_submenu_widget(widget_name: StringName) -> void:
    if not is_instance_valid(submenu_container):
        push_warning("Submenu container is not valid, widget won't be instantiated!")
        return

    var widget_scene := get(widget_name) as PackedScene
    if not is_instance_valid(widget_scene):
        push_warning("Can't instantiate '", widget_name, "' as it is not valid!")
        return

    _previously_focused_control = get_viewport().gui_get_focus_owner()

    # Be safe and don't process anything while a submenu is shown
    # (to avoid accidental press on main menu buttons)
    # NOTE This breaks process mode inheritance
    process_mode = Node.PROCESS_MODE_DISABLED
    focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED

    if is_instance_valid(submenu_decoration):
        submenu_decoration.show()

    var widget := widget_scene.instantiate()
    widget.tree_exited.connect(_on_submenu_exited)
    submenu_container.add_child(widget)
    submenu_container.show()


func _on_submenu_exited() -> void:
    if is_instance_valid(submenu_decoration):
        submenu_decoration.hide()

    submenu_container.hide()

    process_mode = Node.PROCESS_MODE_INHERIT
    focus_behavior_recursive = Control.FOCUS_BEHAVIOR_INHERITED
    if is_instance_valid(_previously_focused_control):
        _previously_focused_control.grab_focus()
        _previously_focused_control = null
