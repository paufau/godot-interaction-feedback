@tool
@icon("uid://do1kt1v6tvhmp")
class_name FeedbackRotationOscillatedEffect
extends FeedbackRangedOscillatorEffect

@export var degrees := 2.0
@export var min_degrees := -2.0
@export var max_degrees := 2.0


func _direct_property() -> StringName:
	return &"degrees"


func _amplitude_properties() -> Array:
	return [&"min_degrees", &"max_degrees"]


func _get_channel() -> FeedbackChannel:
	return FeedbackRotationChannel.instance


func _get_value() -> Variant:
	if mode == Mode.AMPLITUDE:
		return wave_between(deg_to_rad(min_degrees), deg_to_rad(max_degrees))

	return wave_between(0.0, deg_to_rad(degrees))
