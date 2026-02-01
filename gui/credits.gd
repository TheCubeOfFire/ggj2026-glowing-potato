class_name Credits
extends QuickGorillaCredits

@onready var credits_list: RichTextLabel = $VBoxContainer/credits_list

func _ready() -> void:
    super._ready()
    credits_list.add_text(get_full_engine_credits())
    back_button.grab_focus.call_deferred()

func _input(event: InputEvent) -> void:
    if event.is_action_released(&"ui_cancel"):
        _on_back_button_pressed()
    return
