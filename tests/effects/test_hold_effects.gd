extends GdUnitTestSuite

const Env := preload("res://tests/helpers/interaction_feedback_test_env.gd")


func test_scale_effect_grows_on_hover() -> void:
	await _assert_hover_settles(
		FeedbackScaleEffect.new(), func(target: Control): return target.offset_transform_scale,
		Vector2(1.06, 1.06), Vector2.ONE, 500
	)


func test_offset_effect_shifts_on_hover() -> void:
	await _assert_hover_settles(
		FeedbackOffsetEffect.new(), func(target: Control): return target.offset_transform_position,
		Vector2(0, -10), Vector2.ZERO, 200
	)


func test_modulate_effect_tints_on_hover() -> void:
	await _assert_hover_settles(
		FeedbackModulateEffect.new(), func(target: Control): return target.modulate,
		Color(1.1, 1.1, 1.1), Color.WHITE, 200
	)


func test_z_level_effect_raises_on_hover() -> void:
	await _assert_hover_settles(
		FeedbackZLevelEffect.new(), func(target: Control): return target.z_index,
		1, 0, 100
	)


func test_rotation_effect_tilts_on_hover() -> void:
	await _assert_hover_settles(
		FeedbackRotationEffect.new(), func(target: Control): return target.offset_transform_rotation,
		deg_to_rad(4.0), 0.0, 200
	)


func test_cursor_effect_changes_shape_on_hover() -> void:
	await _assert_hover_settles(
		FeedbackCursorEffect.new(), func(target: Control): return target.mouse_default_cursor_shape,
		Input.CURSOR_POINTING_HAND, Input.CURSOR_ARROW, 100
	)


func test_disabled_effect_does_nothing() -> void:
	var effect := FeedbackScaleEffect.new()
	effect.enabled = false

	var env := Env.build(self, effect)
	env.feedback.set_hovered(true)

	for _frame in 3:
		await get_tree().process_frame

	assert_bool(env.target.offset_transform_scale.is_equal_approx(Vector2.ONE)).is_true()


func _assert_hover_settles(effect: FeedbackEffect, read: Callable, hovered: Variant, neutral: Variant, settle_ms: int) -> void:
	var env := Env.build(self, effect)

	env.feedback.set_hovered(true)
	await await_millis(settle_ms)
	assert_bool(_eq(read.call(env.target), hovered)) \
		.override_failure_message("hover should settle the channel at its hovered target") \
		.is_true()

	env.feedback.set_hovered(false)
	await await_millis(settle_ms)
	assert_bool(_eq(read.call(env.target), neutral)) \
		.override_failure_message("release should restore the channel to neutral") \
		.is_true()


func _eq(actual: Variant, expected: Variant) -> bool:
	if actual is Vector2 or actual is Color:
		return actual.is_equal_approx(expected)
	if actual is float:
		return is_equal_approx(actual, expected)
	return actual == expected
