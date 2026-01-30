class_name SB_Timeline
extends Timer
## Allows a Timer to return a ratio using a [Curve] sampled using the [param time_left]
## [param time_left] is normalized in [lb]0;1[rb]
## Emulates a UE Timeline

## Curve to sample to determine the current ratio
@export var ratio_curve : Curve

## Allows to sample the ratio backwards
var backwards : bool = false
## Allows to emulate starting a Timer from a given point instead of 0.0
var use_custom_start_offset : bool = false
## Offset to start from, in [lb]0;1[rb]
var custom_start_offset : float = 0.0

## Indicates that the curve should be sampled backwards on next play
func set_backwards() -> void:
	backwards = true
	if !timeout.is_connected(reset_sampling_modifiers):
		timeout.connect(reset_sampling_modifiers)

## Indicates that the curve should be sampled with a given offset on next play
## Timer still plays normally, but offset is added before curve sampling
## [param offset] MUST be in [rb]0;1[lb], will assert otherwise
func set_offset(offset : float) -> void:
	assert(offset > 0.0 and offset < 1.0)
	use_custom_start_offset = true
	custom_start_offset = offset
	if !timeout.is_connected(reset_sampling_modifiers):
		timeout.connect(reset_sampling_modifiers)
	pass

## Resets all applied sampling modifiers
## Should be called at the end of each timer play that uses modifiers to avoid errors
func reset_sampling_modifiers() -> void:
	if timeout.is_connected(reset_sampling_modifiers):
		timeout.disconnect(reset_sampling_modifiers)
		use_custom_start_offset = false
		custom_start_offset = 0.0
		backwards = false
	pass

## Gets the ratio to use based on [param time_left]
func get_ratio() -> float:
	## Percentage of time left before the timer ends
	var time_left_ratio : float = time_left / wait_time
	## Where to sample the curve - MUST be in [lb]0;1[rb], otherwise it doesn't really make sense
	var sample_time : float = 1 - time_left_ratio
	
	if use_custom_start_offset && custom_start_offset > 0.0 && custom_start_offset < 1.0:
		# Offset is already a percentage so we can just add it
		sample_time += custom_start_offset
		# End timer if we reached the end of the curve this way
		if sample_time >= 1.0:
			stop()
			timeout.emit()
	
	if backwards:
		sample_time = 1 - sample_time
	
	var ratio = ratio_curve.sample(sample_time)
	return ratio
