@tool
extends EditorPlugin

const PLUGIN_NAME = "snowbunny"
const SNOWBUNNY_AUTOLOAD_NAME = "SB"
const SETTING_PATH_ENABLE_DEBUG_DRAW = "snowbunny/globals/debug/enable_debug_draw"

func _enter_tree() -> void:
	add_custom_type("SB_Timeline", "Timer", preload("scripts/sb_timeline.gd"), preload("icons/SB_Timeline.svg"))
	add_custom_type("SB_DebugPropertyDisplay", "RichTextLabel", preload("scripts/sb_debug_property_display.gd"), preload("icons/SB_DebugPropertyDisplay.svg"))
	pass

func _exit_tree() -> void:
	remove_custom_type("SB_Timeline")
	remove_custom_type("SB_DebugPropertyDisplay")
	pass

func _enable_plugin() -> void:
	add_snowbunny_settings()
	add_autoload_singleton(SNOWBUNNY_AUTOLOAD_NAME, "res://addons/snowbunny/sb_globals.gd")
	EditorInterface.set_plugin_enabled(PLUGIN_NAME + "/pixel2d", true)
	return

func _disable_plugin() -> void:
	remove_snow_bunny_settings()
	remove_autoload_singleton(SNOWBUNNY_AUTOLOAD_NAME)
	EditorInterface.set_plugin_enabled(PLUGIN_NAME + "/pixel2d", false)
	return

func add_snowbunny_settings():
	ProjectSettings.set_setting(SETTING_PATH_ENABLE_DEBUG_DRAW, true)
	#ProjectSettings.set_initial_value(SETTING_PATH_ENABLE_DEBUG_DRAW, true)
	return

func remove_snow_bunny_settings():
	ProjectSettings.set_setting(SETTING_PATH_ENABLE_DEBUG_DRAW, null)
	return
