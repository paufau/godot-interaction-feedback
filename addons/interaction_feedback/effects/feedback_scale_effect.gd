@tool
@icon("uid://ur1fgpqekfpo")
class_name FeedbackScaleEffect
extends FeedbackEffect

@export var hovered_scale := 1.06
@export var pressed_scale := 0.96
@export var duration_sec := 0.2
@export var y_lag := 1.75

var _scale := Vector2.ONE


func _init() -> void:
	transition = Tween.TRANS_BACK
	easing = Tween.EASE_OUT


func _get_channel() -> FeedbackChannel:
	return FeedbackScaleChannel.instance


func _get_value() -> Variant:
	return _scale


func _apply_state(hovered: bool, pressed: bool) -> void:
	var value := 1.0

	if pressed:
		value = pressed_scale
	elif hovered:
		value = hovered_scale

	if not _retarget(&"_scale", value):
		return

	_tween_to(value)


func reset() -> void:
	super()
	_scale = Vector2.ONE


func _tween_to(value: float) -> void:
	var tween := _begin_tween() if duration_sec > 0.0 else null

	if tween == null:
		_snap(&"_scale", Vector2.ONE * value)
		return

	tween.set_parallel()
	tween.tween_property(self, ^"_scale:x", value, duration_sec)
	tween.tween_property(self, ^"_scale:y", value, duration_sec * maxf(y_lag, 0.0))
