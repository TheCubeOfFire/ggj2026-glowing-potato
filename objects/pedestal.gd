class_name Pedestal
extends Node3D

# ------- Signal -------
signal on_mask_claimed()

# ------- Exposed vars -------
@export var given_mask: int = 0

# ------- Internal vars -------
var has_mask: bool = true

@onready var mask_mesh: MeshInstance3D = $MaskMesh

# ------- Overriden Engine Functions -------


# ------- Other Functions -------
func claim_mask():
    has_mask = false
    mask_mesh.queue_free()
    on_mask_claimed.emit()
    return
