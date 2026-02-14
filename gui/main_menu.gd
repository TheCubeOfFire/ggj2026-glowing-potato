class_name MainMenu
extends QuickGorillaMainMenu

# ------- Internal vars -------
@onready var play: Button = $VBoxContainer/Play


# ------- Functions -------
func _get_default_focused_control() -> Control:
    return play
