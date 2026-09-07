extends GdUnitTestSuite


func test_mouse_motion_is_mouse() -> void:
	assert_int(FeedbackInputDevice.classify(InputEventMouseMotion.new())) \
		.is_equal(FeedbackInputDevice.Device.MOUSE)


func test_touch_events_are_touch() -> void:
	assert_int(FeedbackInputDevice.classify(InputEventScreenTouch.new())) \
		.is_equal(FeedbackInputDevice.Device.TOUCH)
	assert_int(FeedbackInputDevice.classify(InputEventScreenDrag.new())) \
		.is_equal(FeedbackInputDevice.Device.TOUCH)


func test_joypad_button_press_is_navigation_release_is_unknown() -> void:
	var event := InputEventJoypadButton.new()
	event.pressed = true
	assert_int(FeedbackInputDevice.classify(event)).is_equal(FeedbackInputDevice.Device.NAVIGATION)
	event.pressed = false
	assert_int(FeedbackInputDevice.classify(event)).is_equal(FeedbackInputDevice.Device.UNKNOWN)


func test_joypad_motion_respects_threshold() -> void:
	var event := InputEventJoypadMotion.new()
	event.axis_value = 0.9
	assert_int(FeedbackInputDevice.classify(event)).is_equal(FeedbackInputDevice.Device.NAVIGATION)
	event.axis_value = 0.1
	assert_int(FeedbackInputDevice.classify(event)).is_equal(FeedbackInputDevice.Device.UNKNOWN)


func test_plain_mouse_button_is_unknown() -> void:
	assert_int(FeedbackInputDevice.classify(InputEventMouseButton.new())) \
		.is_equal(FeedbackInputDevice.Device.UNKNOWN)
