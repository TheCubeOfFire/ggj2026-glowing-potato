class_name Credits
extends QuickGorillaCredits


@onready var _credits_list := %CreditsList as RichTextLabel


func _ready() -> void:
    super._ready()
    _credits_list.add_text(get_full_engine_credits())
    _credits_list.grab_focus.call_deferred()
