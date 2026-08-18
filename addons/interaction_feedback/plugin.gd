@tool
extends EditorPlugin

const AUTOLOAD_FEEDBACK_INPUT_MODE := "uid://bt4bdvwsya5a3"


func _enable_plugin() -> void:
	add_autoload_singleton(_get_autoload_name(), AUTOLOAD_FEEDBACK_INPUT_MODE)


func _disable_plugin() -> void:
	remove_autoload_singleton(_get_autoload_name())


func _get_autoload_name() -> String:
	return String(InteractionFeedback.INPUT_MODE_PATH).get_file()
