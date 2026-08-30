@tool
@icon("uid://b8lkn4hv2k84c")
class_name FeedbackModulateOscillatedEffect
extends FeedbackOscillatorEffect

@export var color := Color(1, 0.4, 0.4)


func _get_channel() -> FeedbackChannel:
	return FeedbackModulateChannel.instance


func _get_value() -> Variant:
	return Color.WHITE.lerp(color, wave_between(0.0, 1.0))
