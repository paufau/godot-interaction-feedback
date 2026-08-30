@tool
@icon("uid://ekhqnq0j4ed8")
class_name FeedbackScaleOnceEffect
extends FeedbackTriggerEffect

@export var scale := 0.9
@export var duration_sec := 0.24

var _scale := Vector2.ONE


func _init() -> void:
	transition = Tween.TRANS_BACK
	easing = Tween.EASE_OUT


func _get_channel() -> FeedbackChannel:
	return FeedbackScaleChannel.instance


func _get_value() -> Variant:
	return _scale


func fire() -> void:
	var tween := _begin_tween()

	if tween == null:
		return

	var half_duration := duration_sec / 2.0

	tween.tween_property(self, ^"_scale", Vector2.ONE * scale, half_duration)
	tween.tween_property(self, ^"_scale", Vector2.ONE, half_duration)


func reset() -> void:
	super()
	_scale = Vector2.ONE
