## Utility functions
class_name QuickGorillaUtilities


## Connect a button's pressed signal to a callback with error messages if
## button is not valid.
##
## A property named with the string passed in button_name must exist in parent
## object.
static func safe_connect_button_pressed(parent: Object, button_name: StringName, callback: Callable) -> void:
    if not is_instance_valid(parent):
        push_error("Button connection error: parent object is not valid")
        return

    var button := parent.get(button_name) as BaseButton
    if is_instance_valid(button):
        button.pressed.connect(callback)
    else:
        push_warning("Button '", button_name, "' is not valid, it won't be connected")
