## Rich text label which supports scrolling with gamepad
## (Godot's RichTextLabel doesn't)
class_name QuickGorillaRichText
extends RichTextLabel


## Scroll speed (in px/s) when the stick is at the extreme positions
@export var max_scroll_speed := 1000.0


func _gui_input(event: InputEvent) -> void:
    if (is_instance_of(event, InputEventJoypadButton) \
        or is_instance_of(event, InputEventJoypadMotion)) \
        and (event.is_action(&"ui_down") or \
        event.is_action(&"ui_up")):
            accept_event()


func _process(delta: float) -> void:
    if not has_focus():
        return

    # Bug in Godot preventing scrolling with gamepad in rich text labels
    # (issue 59824)
    var scroll_bar := get_v_scroll_bar()
    var scroll_strength := Input.get_axis(&"ui_up", &"ui_down")
    if is_zero_approx(scroll_strength):
        return

    var new_value := scroll_bar.value + max_scroll_speed * scroll_strength * delta
    new_value = clampf(new_value, scroll_bar.min_value, scroll_bar.max_value - scroll_bar.page)
    scroll_bar.value = new_value
