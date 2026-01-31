class_name MaskPhysicalEffectManager
extends Node


@export var gravity_direction := Vector3.DOWN

@export var mask_area: Area2D

@export var affected_object_group: StringName

var _currently_affected_objects: Array[GravityCube] = []


func _physics_process(_delta: float) -> void:
    var newly_affected_objects: Array[GravityCube] = []

    var camera := get_viewport().get_camera_3d()

    var projection := camera.get_camera_projection()
    var view := camera.global_transform.affine_inverse()
    var proj_view := projection * Projection(view)

    var viewport_size := get_viewport().get_visible_rect().size
    var interactable_objects := get_tree().get_nodes_in_group(affected_object_group)

    for interactable_object: Node in interactable_objects:
        if interactable_object is not GravityCube:
            continue

        var gravity_cube := interactable_object as GravityCube

        var inv_model := gravity_cube.global_transform
        var mesh_proj := proj_view * Projection(inv_model)

        var affected_mesh := gravity_cube.get_mesh()

        var points := PackedVector2Array()
        for vertex in affected_mesh.get_faces():
            var proj_vertex := mesh_proj * Vector4(vertex.x, vertex.y, vertex.z, 1.0)
            var depth := proj_vertex.z / proj_vertex.w
            if depth < 0.0 or depth > 1.0:
                continue

            var vertex_2d := Vector2(proj_vertex.x, -proj_vertex.y)
            vertex_2d /= proj_vertex.w
            vertex_2d = 0.5 * vertex_2d + 0.5 * Vector2.ONE
            vertex_2d *= viewport_size
            points.append(vertex_2d)

        if points.size() < 3:
            continue

        var shape := ConvexPolygonShape2D.new()
        shape.set_point_cloud(points)

        for mask_shape_owner: int in mask_area.get_shape_owners():
            var local_mask_owner_transform := mask_area.shape_owner_get_transform(mask_shape_owner)
            var mask_owner_transform := mask_area.transform * local_mask_owner_transform
            for mask_shape_index: int in mask_area.shape_owner_get_shape_count(mask_shape_owner):
                var mask_shape := mask_area.shape_owner_get_shape(mask_shape_owner, mask_shape_index)
                if mask_shape.collide(mask_owner_transform, shape, Transform2D.IDENTITY):
                    newly_affected_objects.append(gravity_cube)

    for newly_affected_object: GravityCube in newly_affected_objects:
        if not _currently_affected_objects.has(newly_affected_object):
            newly_affected_object.override_gravity(gravity_direction)

    for currently_affected_object: GravityCube in _currently_affected_objects:
        if not newly_affected_objects.has(currently_affected_object):
            currently_affected_object.clear_gravity_override()

    _currently_affected_objects = newly_affected_objects
