class_name SB_DebugPropertyDisplay
extends RichTextLabel
## Allows to display and monitor property values for the parent node at runtime. Can also
## call parent node functions and monitor their return values, as well as monitor sibling nodes

## If the debug displayer should be enabled in game
@export var enabled : bool = true
## Array of [StringName] of variables that should be monitored in the parent node. Can also be function names
## that return a value.
@export var monitored_vars : Array[StringName]
## Array of [Dictionary] of sibling node variables that should be monitored. Can also be function names 
## that return a value. Cannot be properly statically typed yet since nested collections types are 
## not supported.[br]
## Should be typed as [code]Array[Dictionary[StringName,Array[StringName]]][/code], will assert otherwise[br]
## [br]
## Example:
## [codeblock][
##		{ "AnimatedSprite2D": ["position", "get_playing_speed"] },
##		{ "Timer": ["autostart", "is_stopped"] }
## ]
## [/codeblock]
@export var monitored_sibling_vars : Array[Dictionary]

@export_group("Text")
## Font size used for the text
@export var font_size : int = 12
@export_subgroup("Colors")
## Allows to override the colors for values of given types
@export var custom_colors : Dictionary[StringName, Color]

# ------- Internal vars -------
## Ref to the parent node
var parent_node : Node

# ------- Overriden Engine Functions -------
func _ready() -> void:
	parent_node = $".."
	# Entirely disable the node
	if !ProjectSettings.get_setting(SB.SETTING_PATH_ENABLE_DEBUG_DRAW) or !enabled:
		hide()
		set_process(false)
	pass

func _process(_delta: float) -> void:
	clear()
	push_font_size(font_size)
	push_bgcolor(0x263c7880)
	
	for property_name : StringName in monitored_vars:
		if property_name in parent_node:
			display_property(property_name, parent_node)
	
	for sibling_dict : Dictionary in monitored_sibling_vars:
		for sibling_name in sibling_dict.keys():
			assert(sibling_name is StringName, "Ill-formed Dictionary, Component name should be a StringName")
			var sibling_node : Node = parent_node.get_node(str(sibling_name))
			if sibling_node:
				append_text(sibling_name+":\n")
				for property_name in sibling_dict[sibling_name]:
					assert(property_name is StringName, "Ill-formed Dictionary, property name should be a StringName")
					display_property(property_name, sibling_node)
			else:
				append_text("err_sibling_not_found \"" + sibling_name + "\"\n") 
	pass

# ------- Other Functions -------
## Displays a given property in the RichTextLabel text field
func display_property(property_name : StringName, node : Node):
	## The value to display for the given property
	var property_value : Variant = null
	## Whether this property is a method call
	var is_method_call : bool = false
	## Whether the property exists in the given node
	var property_exists = property_name in node
	
	if !property_exists:
		append_text("err_property_not_found \"" + property_name +"\"\n")
		return
		
	property_value = node[property_name]
	if node.has_method(property_name):
		property_value = node[property_name].call()
		is_method_call = true
		
	if is_method_call:
		push_color(0xccccccff)
	
	append_text(property_name)
	if is_method_call:
		append_text("()")
		pop()
	append_text(" = ")
	
	var color : Color = get_property_color(property_value)
	push_color(color)
	append_text(str(property_value)+"\n")
	pop()
	pass

## Gets the color to display the property in, depending on its type
func get_property_color(property : Variant) -> Color:
	var property_class : String = type_string(typeof(property))

	if property_class in custom_colors.keys():
		return custom_colors[property_class]
	
	if property == null:
		return 0x888888ff
	if property is bool:
		if property:
			return 0x00ff00ff
		else:
			return 0xff0000ff
	if property is int or property is float:
		return 0x00ffffff
	if property is Vector2:
		return 0xffff00ff
	return 0xffffffff
