@tool
@icon("uid://p3fo8icepfhp")
class_name FeedbackModulateOnceEffect
extends FeedbackTriggerEffect

@export var color := Color(1, 0.4, 0.4)
@export var duration_sec := 0.2

var _modulate := Color.WHITE


func _init() -> void:
	transition = Tween.TRANS_SINE
	easing = Tween.EASE_OUT


func _get_channel() -> FeedbackChannel:
	return FeedbackModulateChannel.instance


func _get_value() -> Variant:
	return _modulate


func fire() -> void:
	var tween := _begin_tween()

	if tween == null:
		return

	var half_duration := duration_sec / 2.0

	tween.tween_property(self, ^"_modulate", color, half_duration)
	tween.tween_property(self, ^"_modulate", Color.WHITE, half_duration)


func reset() -> void:
	super()
	_modulate = Color.WHITE
