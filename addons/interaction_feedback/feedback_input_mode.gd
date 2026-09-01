extends Node

signal changed(touch_active: bool)
signal device_changed(device: FeedbackInputDevice.Device)

## Touch emulation synthesizes mouse events right after every real touch
## ignoring mouse input briefly keeps those from flipping us straight back
const MOUSE_GRACE_MSEC := 500

var _device: FeedbackInputDevice.Device = FeedbackInputDevice.Device.MOUSE
var _last_touch_msec := -MOUSE_GRACE_MSEC
var _last_joypad_device := 0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_device = (
		FeedbackInputDevice.Device.TOUCH
		if DisplayServer.is_touchscreen_available()
		else FeedbackInputDevice.Device.MOUSE
	)


func is_touch_active() -> bool:
	return _device == FeedbackInputDevice.Device.TOUCH


func is_navigation_active() -> bool:
	return _device == FeedbackInputDevice.Device.NAVIGATION


func get_navigation_joypad() -> int:
	return _last_joypad_device


func _input(event: InputEvent) -> void:
	var device := FeedbackInputDevice.classify(event)

	if device == FeedbackInputDevice.Device.UNKNOWN:
		return

	match device:
		FeedbackInputDevice.Device.TOUCH:
			_last_touch_msec = Time.get_ticks_msec()
		FeedbackInputDevice.Device.MOUSE:
			var motion := event as InputEventMouseMotion

			if motion.relative.is_zero_approx():
				return

			if Time.get_ticks_msec() - _last_touch_msec <= MOUSE_GRACE_MSEC:
				return
		FeedbackInputDevice.Device.NAVIGATION:
			if event is InputEventJoypadButton or event is InputEventJoypadMotion:
				_last_joypad_device = event.device

	_set_device(device)


func _set_device(device: FeedbackInputDevice.Device) -> void:
	if _device == device:
		return

	var was_touch := _device == FeedbackInputDevice.Device.TOUCH
	_device = device
	device_changed.emit(device)

	var is_touch := device == FeedbackInputDevice.Device.TOUCH

	if was_touch != is_touch:
		changed.emit(is_touch)
