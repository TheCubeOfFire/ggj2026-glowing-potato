class_name Credits
extends QuickGorillaCredits

@onready var credits_list: RichTextLabel = $VBoxContainer/credits_list

func _ready() -> void:
    super._ready()
    credits_list.add_text(get_full_engine_credits())
