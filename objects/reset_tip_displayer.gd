@tool
class_name ResetTipDisplayer
extends Area3D

# ------- Exposed vars -------
@export var collision_scale: Vector3 = Vector3(1.0, 1.0, 1.0):
    set (value):
        collision_scale = value
        $CollisionShape3D.scale = value

## If set, the reset tip will only be displayed if this specific gcube enters the area
@export var expected_cube: GravityCube


# ------- Internal vars -------
static var await_time: float = 4.0


# -------  Functions -------
func _on_body_entered(body: Node3D) -> void:
    if Engine.is_editor_hint():
        return

    if body is GravityCube:
        var gcube := body as GravityCube

        if expected_cube and expected_cube != gcube:
            return

        var player := get_tree().get_first_node_in_group(&"player") as MainPlayer
        if player:
            await get_tree().create_timer(await_time).timeout
            player.display_tip(&"TIP_RESET")
