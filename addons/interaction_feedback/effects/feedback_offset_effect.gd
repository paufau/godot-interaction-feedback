@tool
@icon("uid://ng40get0ar56")
class_name FeedbackOffsetEffect
extends FeedbackEffect

@export var hovered_offset := Vector2(0.0, -10.0)
@export var pressed_offset := Vector2.ZERO
@export var duration_sec := 0.12

var _offset := Vector2.ZERO


func _get_channel() -> FeedbackChannel:
	return FeedbackOffsetChannel.instance


func _get_value() -> Variant:
	return _offset


func _apply_state(hovered: bool, pressed: bool) -> void:
	var value := Vector2.ZERO

	if hovered:
		value += hovered_offset

	if pressed:
		value += pressed_offset

	animate(&"_offset", value, duration_sec)


func reset() -> void:
	super()
	_offset = Vector2.ZERO
