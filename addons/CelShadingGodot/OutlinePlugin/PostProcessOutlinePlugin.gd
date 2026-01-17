@tool
extends EditorPlugin

func _enter_tree():
    # Initialization of the plugin goes here.
    add_custom_type("PostProcessOutline", "MeshInstance3D", preload("res://addons/CelShadingGodot/OutlinePlugin/PostProcessOutline.gd"), preload("res://addons/CelShadingGodot/OutlinePlugin/icon/icon_outline.svg"))


func _exit_tree():
    # Clean-up of the plugin goes here.
    remove_custom_type("PostProcessOutline")
