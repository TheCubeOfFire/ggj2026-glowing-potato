class_name MaskHolder
extends Control


# ------- Exposed vars -------
@export_range(0,3,1) var mask_index: int


# ------- Internal vars -------
@onready var mask_container: HBoxContainer = $MaskContainer
@onready var kb_prompt: TextureRect = $MaskContainer/TextureRect
@onready var gamepad_prompt: TextureRect = $MaskContainer/TextureRect2


# ------- Overriden Engine Functions -------
func _ready() -> void:
    match mask_index:
        0:
            kb_prompt.texture = load(&"uid://vccq2l04konm")
            gamepad_prompt.texture = load(&"uid://cptegfdoqtpij")
            pass
        1:
            kb_prompt.texture = load(&"uid://bp40vwtsoyt1a")
            gamepad_prompt.texture = load(&"uid://cs2uehas3cjh3")
            pass
        2:
            kb_prompt.texture = load(&"uid://comrf7ewulutx")
            gamepad_prompt.texture = load(&"uid://dwn8247s01dbl")
            pass
        3:
            kb_prompt.texture = load(&"uid://b3f4nb0pr45gs")
            gamepad_prompt.texture = load(&"uid://cepdpmliqk8gi")
            pass
    return


# ------- Other Functions -------
func set_visibility(value: bool) -> void:
    mask_container.visible = value
    return
