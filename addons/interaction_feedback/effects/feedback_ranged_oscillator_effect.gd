@tool
class_name FeedbackRangedOscillatorEffect
extends FeedbackOscillatorEffect

enum Mode {
	DIRECT,
	AMPLITUDE,
}

@export var mode: Mode = Mode.DIRECT:
	set(value):
		mode = value
		notify_property_list_changed()


func _direct_property() -> StringName:
	return &""


func _amplitude_properties() -> Array:
	return []


func _validate_property(property: Dictionary) -> void:
	super(property)

	if property.name == _direct_property() and mode != Mode.DIRECT:
		property.usage = PROPERTY_USAGE_NONE
	elif property.name in _amplitude_properties() and mode != Mode.AMPLITUDE:
		property.usage = PROPERTY_USAGE_NONE
