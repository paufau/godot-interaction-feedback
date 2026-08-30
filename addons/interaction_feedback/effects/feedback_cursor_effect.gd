@tool
@icon("uid://2gs1mtgx55c3")
class_name FeedbackCursorEffect
extends FeedbackTriggerEffect

@export var shape: Input.CursorShape = Input.CURSOR_POINTING_HAND

var _control: Control
var _original: int = Input.CURSOR_ARROW
var _active := false


func _apply_state(hovered: bool, pressed: bool) -> void:
	var should_apply := (hovered and on_hover) or (pressed and on_press)

	if should_apply == _active:
		return

	_active = should_apply

	if should_apply:
		_apply()
	else:
		_restore()


func _replay_state(hovered: bool, pressed: bool) -> void:
	_apply_state(hovered, pressed)


func uses_tween() -> bool:
	return false


func reset() -> void:
	super()

	if _active:
		_active = false
		_restore()


func _apply() -> void:
	var control := _get_control()

	if control != null:
		_original = control.mouse_default_cursor_shape
		control.mouse_default_cursor_shape = int(shape)
	else:
		Input.set_default_cursor_shape(shape)


func _restore() -> void:
	var control := _get_control()

	if control != null:
		control.mouse_default_cursor_shape = _original
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _get_control() -> Control:
	if _control == null:
		var feedback := get_parent() as InteractionFeedback

		if feedback != null:
			_control = feedback.get_target() as Control

	return _control
