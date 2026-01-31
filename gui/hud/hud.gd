class_name Hud
extends Control

# ------- Internal vars -------
@onready var interact_prompt: VBoxContainer = $'InteractPrompt'


# ------- Overriden Engine Functions -------
func _ready() -> void:
    set_interact_prompt_visibility(false)
    return


# ------- Functions -------
func set_interact_prompt_visibility(value: bool) -> void:
    interact_prompt.visible = value
    return
