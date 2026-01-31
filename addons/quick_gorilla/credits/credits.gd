## Class intended to use as a base for a credits menu
class_name QuickGorillaCredits
extends Control


## Button used to close the credits menu
@export var back_button: BaseButton


func _ready() -> void:
    QuickGorillaUtilities.safe_connect_button_pressed(
        self, &"back_button", _on_back_button_pressed)


## Get a string with all Godot engine's credits and licenses.
##
## This is is similar to the text in the "Third-party licenses" tab of the
## "About" window in the editor
func get_full_engine_credits() -> String:
    var result := "This game uses the following softwares and libraries:\n\n"

    for engine_component: Dictionary in Engine.get_copyright_info():
        var component_name := engine_component.name as String
        result += "- %s \n" % component_name

        for component_part: Dictionary in engine_component.parts:
            for copyright in component_part.copyright:
                result += "\n    \u00A9%s" % copyright

            result += "\n    License: %s\n\n" % component_part.license

    result += "The full license texts for these software"
    result += "and libraries is available below:\n\n"

    var license_info := Engine.get_license_info()
    for engine_license_name: String in license_info:
        var engine_license_text := license_info[engine_license_name] as String
        result += "- %s\n\n" % engine_license_name
        result += "    %s\n\n" % engine_license_text.indent("    ")

    return result


func _on_back_button_pressed() -> void:
    queue_free()
