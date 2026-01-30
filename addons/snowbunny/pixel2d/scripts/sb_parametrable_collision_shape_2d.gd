@tool
class_name SB_ParametrableCollisionShape2D
extends CollisionShape2D

# ------- Exposed vars -------
## Tile extent the shape should cover on the x-axis
@export_range(2, 512, 2, "or_greater", "suffix:texels") var texels_x : int = 32:
	set(value):
		texels_x = value
		if shape is CircleShape2D:
			texels_y = value
		# Capsule height must be at least double the radius
		if shape is CapsuleShape2D and texels_x > texels_y:
			texels_y = texels_x
		recompute_size()

## Tile extent the shape should cover on the y-axis.
## Only used if the shape if defined by 2 parameters
@export_range(2, 512, 2, "or_greater", "suffix:texels") var texels_y : int = 32:
	set(value):
		texels_y = value
		# Capsule radius must be at most half the height
		if shape is CapsuleShape2D and texels_y < texels_x:
			texels_x = texels_y
		recompute_size()

## If [param true], shape size is reduced on the y-axis, so that the bottom pixel is not covered
@export var avoid_double_pixel : bool = false:
	set(value):
		avoid_double_pixel = value
		# If setting to false, we are deactivating DPC
		recompute_size(!avoid_double_pixel)

# ------- Functions -------
## Recomputes the size the shape should be based on the exposed parameters
## [param deactivating_dpc] indicates if deactivating double pixelling correction
## Used to properly reset shape [param position.y]
func recompute_size(deactivating_dpc : bool = false):
	## Used to ensure floating point divisions
	const TWO_AS_FLOAT = 2.0
	var upscale_ratio : int = ProjectSettings.get_setting(SB_Pixel2D.SETTING_PATH_PIXELS_PER_TEXELS)
	var shape_class_name : String = shape.get_class().get_basename()
	
	match shape_class_name:
		"RectangleShape2D":
			var rect : RectangleShape2D = shape
			
			rect.size.x = texels_x * upscale_ratio
			rect.size.y = texels_y * upscale_ratio
		
			if avoid_double_pixel:
				# Upscale ratio is how many pixels make one texel, so we can use it as offset
				rect.size.y -= upscale_ratio
		"CircleShape2D":
			var circle : CircleShape2D = shape
			
			# texels_x is diameter, so half it
			circle.radius = (texels_x * upscale_ratio) / TWO_AS_FLOAT
			
			if avoid_double_pixel:
				circle.radius -= upscale_ratio / TWO_AS_FLOAT
		"CapsuleShape2D":
			var capsule : CapsuleShape2D = shape
			
			# texels_x is "diameter", so half it
			capsule.radius = (texels_x * upscale_ratio) / TWO_AS_FLOAT
			capsule.height = texels_y * upscale_ratio
			
			if avoid_double_pixel:
				# Upscale ratio is how many pixels make one texel, so we can use it as offset
				capsule.height -= upscale_ratio
		_:
			push_warning("Unhandled shape type: \"" + shape.get_class() +  "\"")
			return
	if avoid_double_pixel:
		position.y += -upscale_ratio / TWO_AS_FLOAT
	else:
		if deactivating_dpc:
			# Push shape down if deactivating DPC
			position.y += upscale_ratio / TWO_AS_FLOAT
	pass
