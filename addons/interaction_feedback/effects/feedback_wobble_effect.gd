@tool
@icon("uid://do1kt1v6tvhmp")
class_name FeedbackWobbleEffect
extends FeedbackOscillatorEffect

@export var degrees := 2.0


func _get_channel() -> FeedbackChannel:
	return FeedbackRotationChannel.instance


func _get_value() -> Variant:
	return deg_to_rad(degrees) * wave()
