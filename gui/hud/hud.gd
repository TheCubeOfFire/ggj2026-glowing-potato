class_name Hud
extends Control

# ------- Internal vars -------
@onready var interact_prompt: VBoxContainer = $'InteractPrompt'
@onready var mask0_container: HBoxContainer = $'MaskPromptsContainer/Mask0Holder/Mask0Container'
@onready var mask1_container: HBoxContainer = $'MaskPromptsContainer/Mask1Holder/Mask1Container'
@onready var mask2_container: HBoxContainer = $'MaskPromptsContainer/Mask2Holder/Mask2Container'
@onready var mask3_container: HBoxContainer = $'MaskPromptsContainer/Mask3Holder/Mask3Container'

# ------- Overriden Engine Functions -------
func _ready() -> void:
    set_interact_prompt_visibility(false)
    for mask_index in range(4):
        set_mask_container_visibility(mask_index, false)
    return


# ------- Functions -------
func set_interact_prompt_visibility(value: bool) -> void:
    interact_prompt.visible = value
    return


func set_mask_container_visibility(mask_index: int, value: bool) -> void:
    var mask_container: HBoxContainer
    match mask_index:
        0:
            mask_container = mask0_container
            pass
        1:
            mask_container = mask1_container
            pass
        2:
            mask_container = mask2_container
            pass
        3:
            mask_container = mask3_container
            pass
        _:
            assert(false)
    mask_container.visible = value
    return
