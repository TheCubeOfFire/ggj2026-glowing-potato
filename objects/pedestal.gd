class_name Pedestal
extends Node3D

# ------- Signal -------
signal on_mask_claimed()

# ------- Exposed vars -------
@export var given_mask: int = 0

# ------- Internal vars -------
var has_mask: bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mask_mesh: MeshInstance3D = $MaskMesh
@onready var _white_particle_emitter: GPUParticles3D = $WhiteParticlesEmitter
@onready var _purple_particle_emitter: GPUParticles3D = $PurpleParticlesEmitter

# ------- Overriden Engine Functions -------


# ------- Other Functions -------
func claim_mask():
    has_mask = false
    mask_mesh.queue_free()
    animation_player.play("play_sound")
    _white_particle_emitter.restart()
    _purple_particle_emitter.restart()
    on_mask_claimed.emit()
    return
