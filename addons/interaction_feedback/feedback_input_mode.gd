extends Node

## Tracks whether the game is driven by touch or mouse

signal changed(touch_active: bool)

## Touch emulation synthesizes mouse events right after every real touch
## ignoring mouse input briefly keeps those from flipping us straight back
const MOUSE_GRACE_MSEC := 500

var _touch_active := false
var _last_touch_msec := -MOUSE_GRACE_MSEC


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_touch_active = DisplayServer.is_touchscreen_available()


func is_touch_active() -> bool:
	return _touch_active


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		_last_touch_msec = Time.get_ticks_msec()
		_set_touch_active(true)
		return

	if event is InputEventMouseMotion:
		var motion := event as InputEventMouseMotion

		if motion.relative.is_zero_approx():
			return

		if Time.get_ticks_msec() - _last_touch_msec > MOUSE_GRACE_MSEC:
			_set_touch_active(false)


func _set_touch_active(value: bool) -> void:
	if _touch_active == value:
		return

	_touch_active = value
	changed.emit(value)
