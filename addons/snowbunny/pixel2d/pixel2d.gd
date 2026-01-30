@tool
extends EditorPlugin

const PIXEL2D_AUTOLOAD_NAME : String = "SB_Pixel2D"
const SETTING_PATH_TEXTURE_SIZE : String = "snowbunny/pixel2d/tile/texture_size"
const SETTING_PATH_PIXELS_PER_TEXELS : String = "snowbunny/pixel2d/tile/pixels_per_texels"

func _enter_tree() -> void:
	add_custom_type("SB_ParametrableCollisionShape2D", "CollisionShape2D", preload("scripts/sb_parametrable_collision_shape_2d.gd"), preload("icons/SB_ParametrableCollisionShape2D.svg"))
	pass

func _exit_tree() -> void:
	remove_custom_type("SB_ParametrableCollisionShape2D")
	pass

func _enable_plugin() -> void:
	add_pixel2d_settings()
	add_autoload_singleton(PIXEL2D_AUTOLOAD_NAME, "res://addons/snowbunny/pixel2d/pixel2d_globals.gd")
	return

func _disable_plugin() -> void:
	remove_pixel2d_settings()
	remove_autoload_singleton(PIXEL2D_AUTOLOAD_NAME)
	return

func add_pixel2d_settings() -> void:
	ProjectSettings.set_setting(SETTING_PATH_TEXTURE_SIZE, 32)
	# Known issue #108153
	# Uncomment once fixed
	# See https://github.com/godotengine/godot/issues/108153
	#ProjectSettings.set_initial_value(SETTING_PATH_TEXTURE_SIZE, 32)
	
	ProjectSettings.set_setting(SETTING_PATH_PIXELS_PER_TEXELS, 1)
	#ProjectSettings.set_initial_value(SETTING_PIXELS_PER_TEXELS, 1)
	return

func remove_pixel2d_settings() -> void:
	ProjectSettings.set_setting(SETTING_PATH_TEXTURE_SIZE, null)
	ProjectSettings.set_setting(SETTING_PATH_PIXELS_PER_TEXELS, null)
	return
