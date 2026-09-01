@tool
@icon("uid://cqohaxs7jh6lk")
class_name FeedbackHapticEffect
extends FeedbackTriggerEffect

@export_range(1, 500, 1, "suffix:ms") var duration_msec := 20
@export_range(-1.0, 1.0, 0.05) var amplitude := 0.4


func _init() -> void:
	on_hover = false
	on_press = true


func fire() -> void:
	var input_mode := _try_get_input_mode()

	if input_mode != null and input_mode.is_navigation_active():
		var magnitude := clampf(amplitude, 0.0, 1.0)

		Input.start_joy_vibration(
			input_mode.get_navigation_joypad(),
			magnitude,
			magnitude,
			maxi(duration_msec, 1) / 1000.0
		)
	else:
		Input.vibrate_handheld(duration_msec, amplitude)


func uses_tween() -> bool:
	return false


func _try_get_input_mode() -> Node:
	var feedback := get_parent() as InteractionFeedback

	return feedback.get_input_mode() if feedback != null else null
