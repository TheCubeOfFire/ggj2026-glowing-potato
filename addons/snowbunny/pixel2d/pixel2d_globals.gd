@tool
extends Node

const SETTING_PATH_TEXTURE_SIZE : String = "snowbunny/pixel2d/tile/texture_size"
const SETTING_PATH_PIXELS_PER_TEXELS : String = "snowbunny/pixel2d/tile/pixels_per_texels"

func get_tile_size() -> int:
	var texture_size : int = ProjectSettings.get_setting(SETTING_PATH_TEXTURE_SIZE)
	var pixels_per_texels : int = ProjectSettings.get_setting(SETTING_PATH_PIXELS_PER_TEXELS)
	return texture_size * pixels_per_texels
