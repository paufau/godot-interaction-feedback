@tool
@icon("uid://b2jgxuywv33ir")
class_name FeedbackRotationOnceEffect
extends FeedbackTriggerEffect

@export var degrees := 1.5
@export var duration_sec := 0.16

var _rotation := 0.0


func _init() -> void:
	transition = Tween.TRANS_SINE
	easing = Tween.EASE_OUT


func _get_channel() -> FeedbackChannel:
	return FeedbackRotationChannel.instance


func _get_value() -> Variant:
	return _rotation


func fire() -> void:
	var tween := _begin_tween()

	if tween == null:
		return

	var direction := -1.0 if randf() < 0.5 else 1.0

	var half_duration := duration_sec / 2.0

	tween.tween_property(self, ^"_rotation", deg_to_rad(degrees) * direction, half_duration)
	tween.tween_property(self, ^"_rotation", 0.0, half_duration)


func reset() -> void:
	super()
	_rotation = 0.0
