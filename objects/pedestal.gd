class_name Pedestal
extends Node3D

# ------- Signal -------
signal on_mask_claimed()

# ------- Exposed vars -------
@export var given_mask: int = 0

# ------- Internal vars -------
var has_mask: bool = true

@onready var mask_mesh: MeshInstance3D = $MaskMesh
@onready var particle_emitter: GPUParticles3D = $GPUParticles3D

# ------- Overriden Engine Functions -------


# ------- Other Functions -------
func claim_mask():
    has_mask = false
    mask_mesh.queue_free()
    particle_emitter.restart()
    on_mask_claimed.emit()
    return
