class_name CubeSwitch
extends StaticBody3D
## Expects a [GravityCube] of a given [enum Globals.GCUBE_TYPE] to be powered

# ------- Signal -------
## Emitted when the switch is activated
signal on_activated()
## Emitted when the switch is deactivated
signal on_deactivated()

# ------- Exposed vars -------
## Shape the [GravityCube] should be to power the switch
@export var accepted_cube_type := Globals.GCUBE_TYPE.SQUARE


# ------- Internal vars -------
## Number of cubes that are of the accepted type AND in the detection area
var _current_activating_cubes : int = 0


@onready var activate_sound: AudioStreamPlayer3D = $ActivateSound
@onready var deactivate_sound: AudioStreamPlayer3D = $DeactivateSound
@onready var activated_particle_emitter: GPUParticles3D = $GPUParticles3D

# ------- Overriden Engine Functions -------
func _ready() -> void:
    match accepted_cube_type:
        Globals.GCUBE_TYPE.SQUARE:
            $Square_Switch.mesh = load(&"uid://cpw1b3ay6o681")
            activated_particle_emitter.draw_pass_1 = load(&"uid://dau0dywhghesd")
            pass

        Globals.GCUBE_TYPE.TRIANGLE:
            $Square_Switch.mesh = load(&"uid://b2md5rkxvaopn")
            activated_particle_emitter.draw_pass_1 = load(&"uid://bggfm07mc0roq")
            pass

        Globals.GCUBE_TYPE.CIRCLE:
            $Square_Switch.mesh = load(&"uid://eg6imty2sgjw")
            activated_particle_emitter.draw_pass_1 = load(&"uid://bq5432m4w0qrp")
            pass
    return


# ------- Functions -------
#region cube detection
func _on_cube_detection_area_body_entered(body: Node3D) -> void:
    if body is GravityCube:
        var gravity_cube := body as GravityCube
        if accepted_cube_type != gravity_cube.cube_type:
            return

        add_activating_cube()
    return


func _on_cube_detection_area_body_exited(body: Node3D) -> void:
    if !self.is_queued_for_deletion() and body is GravityCube:
        var gravity_cube := body as GravityCube
        if accepted_cube_type != gravity_cube.cube_type:
            return

        remove_activating_cube()
    return
#endregion


func get_current_activating_cubes() -> int:
    return _current_activating_cubes


## Registers that a [GravityCube] of the expected [enum Globals.GCUBE_TYPE] entered the detection area
func add_activating_cube() -> void:
    _current_activating_cubes += 1
    activate_sound.play()
    if _current_activating_cubes == 1:
        on_activated.emit()
        activated_particle_emitter.emitting = true
    return


## Registers that a [GravityCube] of the expected [enum Globals.GCUBE_TYPE] exited the detection area
func remove_activating_cube() -> void:
    assert(_current_activating_cubes > 0)
    _current_activating_cubes -= 1

    # Prevent errors that can happen when returning to main_menu
    if deactivate_sound.is_inside_tree() and !deactivate_sound.is_queued_for_deletion():
        deactivate_sound.play()

    if _current_activating_cubes == 0:
        on_deactivated.emit()
        activated_particle_emitter.emitting = false
    return
