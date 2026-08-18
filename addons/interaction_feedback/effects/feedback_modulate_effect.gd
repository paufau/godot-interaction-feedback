@tool
@icon("uid://b8lkn4hv2k84c")
class_name FeedbackModulateEffect
extends FeedbackEffect

@export var hovered_modulate := Color(1.1, 1.1, 1.1)
@export var pressed_modulate := Color(0.9, 0.9, 0.9)
@export var duration_sec := 0.12

var _modulate := Color.WHITE


func _get_channel() -> FeedbackChannel:
	return FeedbackModulateChannel.instance


func _get_value() -> Variant:
	return _modulate


func _apply_state(hovered: bool, pressed: bool) -> void:
	var value := Color.WHITE

	if pressed:
		value = pressed_modulate
	elif hovered:
		value = hovered_modulate

	animate(&"_modulate", value, duration_sec)


func reset() -> void:
	super()
	_modulate = Color.WHITE
