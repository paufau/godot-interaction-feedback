extends GdUnitTestSuite

const DEMO := "res://addons/interaction_feedback/demo/demo_controls.tscn"


func test_hovering_the_scale_button_grows_it() -> void:
	var runner := scene_runner(DEMO)
	await runner.simulate_frames(6)

	var button: Control = runner.scene().find_child("ScaleConstant", true, false)
	assert_object(button).is_not_null()
	var viewport := button.get_viewport()

	runner.simulate_mouse_move(viewport.get_screen_transform() * button.get_global_rect().get_center())
	await runner.await_input_processed()
	await runner.simulate_frames(40)
	assert_bool(button.offset_transform_scale.is_equal_approx(Vector2(1.06, 1.06))) \
		.override_failure_message("hovering the scale button should grow it to 1.06") \
		.is_true()

	runner.simulate_mouse_move(Vector2.ZERO)
	await runner.await_input_processed()
	await runner.simulate_frames(40)
	assert_bool(button.offset_transform_scale.is_equal_approx(Vector2.ONE)).is_true()
