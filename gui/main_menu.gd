class_name MainMenu
extends QuickGorillaMainMenu
@onready var play: Button = $VBoxContainer/Play

func _get_default_focused_control() -> Control:
    return play
