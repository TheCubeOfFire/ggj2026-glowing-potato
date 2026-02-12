class_name Hud
extends Control

# ------- Internal vars -------
@onready var animation_player: AnimationPlayer = $'AnimationPlayer'
@onready var interact_prompt: VBoxContainer = $'InteractPrompt'
@onready var mask0_holder: MaskHolder = $MaskPromptsContainer/Mask0Holder
@onready var mask1_holder: MaskHolder = $MaskPromptsContainer/Mask1Holder
@onready var mask2_holder: MaskHolder = $MaskPromptsContainer/Mask2Holder
@onready var mask3_holder: MaskHolder = $MaskPromptsContainer/Mask3Holder
@onready var tip_label: Label = $TipLabel

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
    var mask_holder: MaskHolder
    match mask_index:
        0:
            mask_holder = mask0_holder
            pass
        1:
            mask_holder = mask1_holder
            pass
        2:
            mask_holder = mask2_holder
            pass
        3:
            mask_holder = mask3_holder
            pass
        _:
            assert(false)
    mask_holder.set_visibility(value)
    return

#region tips
func display_tip(tip_key: StringName) -> void:
    tip_label.text = tip_key
    animation_player.play(&"fade_in")
    return

func clear_tips(fade_out: bool) -> void:
    if fade_out:
        animation_player.play_backwards(&"fade_in")
        await animation_player.animation_finished
    tip_label.text = ""
    return
#endregion
