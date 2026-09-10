extends GdUnitTestSuite

const Env := preload("res://tests/helpers/interaction_feedback_test_env.gd")


func test_virtual_pointer_drives_sticky() -> void:
	var env := Env.build(self, FeedbackStickyEffect.new())
	await get_tree().process_frame
	var center := env.target.get_global_rect().get_center()

	env.feedback.set_virtual_pointer(center + Vector2(40.0, 0.0))
	await await_millis(300)
	assert_bool(env.target.offset_transform_position.x > 0.5) \
		.override_failure_message("sticky should lean toward the virtual pointer") \
		.is_true()

	env.feedback.set_virtual_pointer(Vector2.INF)
	await await_millis(700)
	assert_bool(env.target.offset_transform_position.length() < 0.5) \
		.override_failure_message("sticky should settle back when the virtual pointer leaves") \
		.is_true()


func test_virtual_pointer_presses() -> void:
	var env := Env.build(self, FeedbackScaleEffect.new())
	var center := env.target.get_global_rect().get_center()

	env.feedback.set_virtual_pointer(center, true)
	await await_millis(500)
	assert_bool(env.target.offset_transform_scale.is_equal_approx(Vector2(0.96, 0.96))) \
		.override_failure_message("a pressed virtual pointer should settle the pressed scale") \
		.is_true()

	env.feedback.set_virtual_pointer(center, false)
	await await_millis(500)
	assert_bool(env.target.offset_transform_scale.is_equal_approx(Vector2(1.06, 1.06))) \
		.override_failure_message("releasing should fall back to the hovered scale") \
		.is_true()


func test_virtual_pointer_respects_disabled_button() -> void:
	var env := Env.build(self, FeedbackScaleEffect.new())
	env.target.disabled = true

	env.feedback.set_virtual_pointer(env.target.get_global_rect().get_center(), true)
	await await_millis(300)
	assert_bool(env.feedback.is_hovered()).is_false()
	assert_bool(env.feedback.is_pressed()).is_false()
	assert_bool(env.target.offset_transform_scale.is_equal_approx(Vector2.ONE)).is_true()
