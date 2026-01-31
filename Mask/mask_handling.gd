class_name MaskHandling
extends Node2D

# ------- Exposed vars -------
## Should be all false on release, use override to debug
@export var _mask_active_status: Array[bool] = [false, false, false, false]


# ------- Overriden Engine Functions -------
func _ready() -> void:
    $Mask0.visible = _mask_active_status[0]
    $Mask1.visible = _mask_active_status[1]
    $Mask2.visible = _mask_active_status[2]
    $Mask3.visible = _mask_active_status[3]
    return


# ------- Other Functions -------
func is_mask_active(mask_index: int) -> bool:
    assert(0<= mask_index and mask_index <= 3)
    return _mask_active_status[mask_index]

func toggle_mask_visual(mask_index: int) -> bool:
    assert(0<= mask_index and mask_index <= 3)
    _mask_active_status[mask_index] = !_mask_active_status[mask_index]

    var mask_to_toggle: Node2D
    match mask_index:
        0:
            mask_to_toggle = $Mask0
            pass
        1:
            mask_to_toggle = $Mask1
            pass
        2:
            mask_to_toggle = $Mask2
            pass
        3:
            mask_to_toggle = $Mask3
            pass

    mask_to_toggle.visible = !mask_to_toggle.is_visible_in_tree()
    return _mask_active_status[mask_index]

func get_masks() -> Array[Node2D]:
    var masks : Array[Node2D]
    var children = get_children()
    for child in children :
        masks.append(child as Node2D)
    return masks
