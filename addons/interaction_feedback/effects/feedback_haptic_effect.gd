@tool
@icon("uid://cqohaxs7jh6lk")
class_name FeedbackHapticEffect
extends FeedbackTriggerEffect

@export_range(1, 500, 1, "suffix:ms") var duration_msec := 20
@export_range(-1.0, 1.0, 0.05) var amplitude := -1.0


func _init() -> void:
	on_hover = false
	on_press = true


func fire() -> void:
	Input.vibrate_handheld(duration_msec, amplitude)


func uses_tween() -> bool:
	return false
