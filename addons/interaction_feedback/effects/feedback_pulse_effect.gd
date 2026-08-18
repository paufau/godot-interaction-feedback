@tool
@icon("uid://dtf032vo5n4ob")
class_name FeedbackPulseEffect
extends FeedbackOscillatorEffect

@export var amplitude := 0.04


func _get_channel() -> FeedbackChannel:
	return FeedbackScaleChannel.instance


func _get_value() -> Variant:
	return Vector2.ONE * (1.0 + wave() * amplitude)
