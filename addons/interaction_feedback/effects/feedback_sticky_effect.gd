@tool
@icon("uid://du2b2cvoeejoc")
class_name FeedbackStickyEffect
extends FeedbackEffect

const SETTLE_EPSILON_PX := 0.1

@export_range(0.0, 1.0, 0.01) var strength := 0.25
@export var max_offset_px := 12.0
@export var follow_speed := 18.0
@export var release_speed := 9.0

var _offset := Vector2.ZERO
var _anchor := Vector2.ZERO
var _stuck := false
var _canvas_item: CanvasItem


func _tick(delta: float) -> void:
	var desired := Vector2.ZERO

	if _stuck:
		var item := _get_item()

		if item != null:
			desired = ((item.get_global_mouse_position() - _anchor) * strength).limit_length(
				max_offset_px
			)

	var speed := follow_speed if _stuck else release_speed
	_offset = _offset.lerp(desired, 1.0 - exp(-maxf(speed, 0.0) * delta))

	if not _stuck and _offset.length() < SETTLE_EPSILON_PX:
		_offset = Vector2.ZERO


func _get_channel() -> FeedbackChannel:
	return FeedbackOffsetChannel.instance


func _get_value() -> Variant:
	return _offset


func _apply_state(hovered: bool, _pressed: bool) -> void:
	if _stuck == hovered:
		return

	_stuck = hovered

	if _stuck:
		_anchor = _get_centre()

	animation_started.emit()


func is_animating() -> bool:
	return _stuck or _offset != Vector2.ZERO


func uses_tween() -> bool:
	return false


func reset() -> void:
	super()

	_offset = Vector2.ZERO
	_stuck = false


func _get_centre() -> Vector2:
	var item := _get_item()

	if item == null:
		return Vector2.ZERO

	if item is Control:
		return (item as Control).get_global_rect().get_center()

	return (item as Node2D).global_position


func _get_item() -> CanvasItem:
	if _canvas_item == null:
		var feedback := get_parent() as InteractionFeedback

		if feedback != null:
			_canvas_item = feedback.get_target()

	return _canvas_item
