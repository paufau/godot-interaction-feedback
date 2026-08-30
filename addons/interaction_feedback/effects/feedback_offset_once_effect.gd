@tool
@icon("uid://4jwsonncv043")
class_name FeedbackOffsetOnceEffect
extends FeedbackTriggerEffect

enum Mode {DIRECT, RANDOM_DIRECTION}

@export var mode := Mode.DIRECT
@export var offset := Vector2(0, -8)
@export var duration_sec := 0.16

var _offset := Vector2.ZERO


func _init() -> void:
	transition = Tween.TRANS_SINE
	easing = Tween.EASE_OUT


func _get_channel() -> FeedbackChannel:
	return FeedbackOffsetChannel.instance


func _get_value() -> Variant:
	return _offset


func fire() -> void:
	var tween := _begin_tween()

	if tween == null:
		return

	var target := offset

	if mode == Mode.RANDOM_DIRECTION:
		target = Vector2(
			offset.x * (-1.0 if randf() < 0.5 else 1.0),
			offset.y * (-1.0 if randf() < 0.5 else 1.0)
		)

	var half_duration := duration_sec / 2.0

	tween.tween_property(self, ^"_offset", target, half_duration)
	tween.tween_property(self, ^"_offset", Vector2.ZERO, half_duration)


func reset() -> void:
	super()
	_offset = Vector2.ZERO
