extends GdUnitTestSuite

const DEMO := "res://addons/interaction_feedback/demo/demo_controls.tscn"


func test_cursor_hover_drives_scale() -> void:
	await _assert_cursor_hover_drives("ScaleConstant", func(node: Control): return node.offset_transform_scale, Vector2.ONE)


func test_cursor_hover_drives_rotation() -> void:
	await _assert_cursor_hover_drives("RotationConstant", func(node: Control): return node.offset_transform_rotation, 0.0)


func test_cursor_hover_drives_offset() -> void:
	await _assert_cursor_hover_drives("OffsetConstant", func(node: Control): return node.offset_transform_position, Vector2.ZERO)


func test_cursor_hover_drives_modulate() -> void:
	await _assert_cursor_hover_drives("ModulateConstant", func(node: Control): return node.modulate, Color.WHITE)


func _assert_cursor_hover_drives(button_name: String, read: Callable, neutral: Variant) -> void:
	var runner := scene_runner(DEMO)
	await runner.simulate_frames(6)

	var button: Control = runner.scene().find_child(button_name, true, false)
	assert_object(button).is_not_null()
	var to_window := button.get_viewport().get_screen_transform()

	runner.simulate_mouse_move(to_window * button.get_global_rect().get_center())
	await runner.await_input_processed()
	await await_millis(400)
	assert_bool(_is_neutral(read.call(button), neutral)) \
		.override_failure_message("hovering %s should drive its effect" % button_name) \
		.is_false()

	runner.simulate_mouse_move(Vector2.ZERO)
	await runner.await_input_processed()
	await await_millis(600)
	assert_bool(_is_neutral(read.call(button), neutral)) \
		.override_failure_message("leaving %s should restore it" % button_name) \
		.is_true()


func _is_neutral(value: Variant, neutral: Variant) -> bool:
	if value is Vector2 or value is Color:
		return value.is_equal_approx(neutral)
	if value is float:
		return is_equal_approx(value, neutral)
	return value == neutral
