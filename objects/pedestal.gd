class_name Pedestal
extends Node3D
## Holds a mask that can be claimed by the [MainPlayer]

# ------- Signal -------
## Emitted when the held mask is claimed
signal on_mask_claimed()

# ------- Exposed vars -------
## Index of the mask to unlock when claimed
@export var given_mask: int = 0

# ------- Internal vars -------
## Whether the mask is currently held, therefore claimable
var has_mask: bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mask_mesh: StaticBody3D = $MaskBody
@onready var _white_particle_emitter: GPUParticles3D = $WhiteParticlesEmitter
@onready var _purple_particle_emitter: GPUParticles3D = $PurpleParticlesEmitter

# ------- Overriden Engine Functions -------


# ------- Other Functions -------
## Claims thie mask from the pedestal
func claim_mask():
    has_mask = false
    mask_mesh.queue_free()
    animation_player.play("play_sound")
    _white_particle_emitter.restart()
    _purple_particle_emitter.restart()
    on_mask_claimed.emit()
    return
