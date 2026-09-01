@tool
class_name FeedbackInputDevice
extends RefCounted

enum Device {
	UNKNOWN,
	MOUSE,
	TOUCH,
	## Gamepad or keyboard driving focus navigation
	NAVIGATION,
}

const AXIS_THRESHOLD := 0.5

const NAVIGATION_ACTIONS: Array[StringName] = [
	&"ui_up",
	&"ui_down",
	&"ui_left",
	&"ui_right",
	&"ui_focus_next",
	&"ui_focus_prev",
	&"ui_accept",
	&"ui_select",
	&"ui_cancel",
]


static func classify(event: InputEvent) -> Device:
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		return Device.TOUCH

	if event is InputEventMouseMotion:
		return Device.MOUSE

	if event is InputEventJoypadButton:
		return Device.NAVIGATION if (event as InputEventJoypadButton).pressed else Device.UNKNOWN

	if event is InputEventJoypadMotion:
		return Device.NAVIGATION if absf((event as InputEventJoypadMotion).axis_value) >= AXIS_THRESHOLD else Device.UNKNOWN

	if event is InputEventKey and _is_navigation_key(event):
		return Device.NAVIGATION

	return Device.UNKNOWN


static func _is_navigation_key(event: InputEvent) -> bool:
	for action in NAVIGATION_ACTIONS:
		if event.is_action_pressed(action):
			return true

	return false
