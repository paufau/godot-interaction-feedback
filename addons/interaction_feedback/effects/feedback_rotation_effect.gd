@tool
@icon("uid://bfipuopdhwuhb")
class_name FeedbackRotationEffect
extends FeedbackEffect

@export var hovered_degrees := 4.0
@export var pressed_degrees := 0.0
@export var duration_sec := 0.12

var _degrees := 0.0


func _get_channel() -> FeedbackChannel:
	return FeedbackRotationChannel.instance


func _get_value() -> Variant:
	return deg_to_rad(_degrees)


func _apply_state(hovered: bool, pressed: bool) -> void:
	var value := 0.0

	if pressed:
		value = pressed_degrees
	elif hovered:
		value = hovered_degrees

	animate(&"_degrees", value, duration_sec)


func reset() -> void:
	super()
	_degrees = 0.0
