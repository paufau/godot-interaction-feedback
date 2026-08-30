@tool
@icon("uid://dtf032vo5n4ob")
class_name FeedbackScaleOscillatedEffect
extends FeedbackRangedOscillatorEffect

@export var scale := 1.05
@export var min_scale := 0.95
@export var max_scale := 1.05


func _direct_property() -> StringName:
	return &"scale"


func _amplitude_properties() -> Array:
	return [&"min_scale", &"max_scale"]


func _get_channel() -> FeedbackChannel:
	return FeedbackScaleChannel.instance


func _get_value() -> Variant:
	if mode == Mode.AMPLITUDE:
		return _scale_between(min_scale, max_scale)

	return _scale_between(1.0, scale)


func _scale_between(from: float, to: float) -> Vector2:
	return Vector2.ONE * (1.0 + wave_between(from - 1.0, to - 1.0))
