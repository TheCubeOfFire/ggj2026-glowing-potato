extends Node

const SETTING_PATH_ENABLE_DEBUG_DRAW = "snowbunny/globals/debug/enable_debug_draw"

## From the scene's root, gets all nodes that meet a given condition.[br]
##[param condition] must be a function that takes 1 [Node] as parameter.[br]
##[br]
##Example:
##[codeblock]var lambda = func (node: Node) -> bool:
##		return node is Sprite2D
##
##var array : Array[Node] = get_all_nodes_matching(lambda)
##[/codeblock]
##[br]
## Similar to Unreal's GetAllActorsOfClass(). Can probably be expensive, so avoid calling it every tick!
func get_all_nodes_matching(condition: Callable) -> Array[Node]:
	var root = get_tree().root
	var scene_root : Node = root.get_child(root.get_child_count()-1)
	
	if condition.get_argument_count() != 1:
		push_error("lambda \"" + str(condition) + "\" should only take 1 Node as arguments - Returning...")
		return []
	
	return get_all_nodes_matching_internal(condition, scene_root)

## Do [b]not[/b] call directly![br]
## Internal function used by [method get_all_nodes_matching]
func get_all_nodes_matching_internal(condition: Callable, parent: Node) -> Array[Node]:
	var res : Array[Node] = []
	if condition.call(parent):
		res.append(parent)
	for child_node in parent.get_children(true):
		res.append_array(get_all_nodes_matching_internal(condition, child_node))
	return res
