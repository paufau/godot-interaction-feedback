@tool
@icon("uid://dpa8436ds8jyt")
class_name FeedbackOffsetOscillatedEffect
extends FeedbackRangedOscillatorEffect

@export var offset := Vector2(0, 8)
@export var min_offset := Vector2(0, -6)
@export var max_offset := Vector2(0, 6)


func _direct_property() -> StringName:
	return &"offset"


func _amplitude_properties() -> Array:
	return [&"min_offset", &"max_offset"]


func _get_channel() -> FeedbackChannel:
	return FeedbackOffsetChannel.instance


func _get_value() -> Variant:
	if mode == Mode.AMPLITUDE:
		return Vector2(
			wave_between(min_offset.x, max_offset.x),
			wave_between(min_offset.y, max_offset.y)
		)

	return Vector2(wave_between(0.0, offset.x), wave_between(0.0, offset.y))
