@tool
@icon("uid://b6d2jri5qa3ft")
class_name FeedbackOscillatorEffect
extends FeedbackEffect

enum Trigger {
	ALWAYS,
	WHILE_HOVERED,
	WHILE_PRESSED,
}

@export var trigger: Trigger = Trigger.ALWAYS

@export_range(0.1, 10.0, 0.05, "or_greater", "suffix:s") var period_sec := 1.6
@export_range(0.0, 5.0, 0.05, "or_greater", "suffix:s") var fade_sec := 0.25

var _phase := 0.0
var _amount := 0.0
var _target_amount := 0.0
var _hovered := false
var _pressed := false


func _ready() -> void:
	if not Engine.is_editor_hint():
		_update_target_amount()


func _tick(delta: float) -> void:
	if period_sec > 0.0:
		_phase = fmod(_phase + TAU * delta / period_sec, TAU)

	var step := 1.0 if fade_sec <= 0.0 else delta / fade_sec
	_amount = move_toward(_amount, _target_amount, step)


func wave() -> float:
	return sin(_phase) * _amount


func _apply_state(hovered: bool, pressed: bool) -> void:
	_hovered = hovered
	_pressed = pressed
	_update_target_amount()


func is_animating() -> bool:
	return not (is_zero_approx(_amount) and is_zero_approx(_target_amount))


func uses_tween() -> bool:
	return false


func reset() -> void:
	super()

	_phase = 0.0
	_amount = 0.0
	_target_amount = 0.0
	_hovered = false
	_pressed = false

	# The resting state of an ALWAYS sway is swaying; fade back in
	if not Engine.is_editor_hint():
		_update_target_amount()


func _update_target_amount() -> void:
	_target_amount = 1.0 if _should_sway() else 0.0

	if is_zero_approx(_target_amount) and is_zero_approx(_amount):
		return

	animation_started.emit()


func _should_sway() -> bool:
	if not enabled:
		return false

	match trigger:
		Trigger.WHILE_HOVERED:
			return _hovered
		Trigger.WHILE_PRESSED:
			return _pressed

	return true
