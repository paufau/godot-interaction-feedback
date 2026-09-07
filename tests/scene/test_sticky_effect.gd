extends GdUnitTestSuite


func test_sticky_effect_leans_toward_the_pointer() -> void:
	var button := Button.new()
	button.custom_minimum_size = Vector2(200, 200)
	auto_free(button)

	var runner := scene_runner(button)
	var feedback := InteractionFeedback.attach(button, true)
	feedback.add_effect(FeedbackStickyEffect.new())

	await runner.simulate_frames(4)

	var to_window := button.get_viewport().get_screen_transform()
	var rect := button.get_global_rect()

	runner.simulate_mouse_move(to_window * rect.get_center())
	await runner.await_input_processed()
	await await_millis(80)

	runner.simulate_mouse_move(to_window * (rect.get_center() + Vector2(rect.size.x * 0.4, 0.0)))
	await runner.await_input_processed()
	await await_millis(300)
	assert_bool(button.offset_transform_position.x > 0.5) \
		.override_failure_message("sticky should lean the node toward the pointer") \
		.is_true()

	runner.simulate_mouse_move(to_window * (rect.end + Vector2(40.0, 40.0)))
	await runner.await_input_processed()
	await await_millis(700)
	assert_bool(button.offset_transform_position.length() < 0.5) \
		.override_failure_message("sticky should settle back when the pointer leaves") \
		.is_true()
