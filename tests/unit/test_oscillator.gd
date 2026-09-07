extends GdUnitTestSuite


func test_wave_scales_sine_by_amount() -> void:
	var oscillator: FeedbackOscillatorEffect = auto_free(FeedbackOscillatorEffect.new())
	oscillator._sin_phase = 1.0
	oscillator._amount = 1.0
	assert_bool(is_equal_approx(oscillator.wave(), 1.0)).is_true()
	oscillator._amount = 0.5
	assert_bool(is_equal_approx(oscillator.wave(), 0.5)).is_true()
	oscillator._sin_phase = 0.0
	assert_bool(is_equal_approx(oscillator.wave(), 0.0)).is_true()


func test_wave_between_maps_into_range() -> void:
	var oscillator: FeedbackOscillatorEffect = auto_free(FeedbackOscillatorEffect.new())
	oscillator._amount = 1.0
	oscillator._sin_phase = 1.0
	assert_bool(is_equal_approx(oscillator.wave_between(0.0, 10.0), 10.0)).is_true()
	oscillator._sin_phase = -1.0
	assert_bool(is_equal_approx(oscillator.wave_between(0.0, 10.0), 0.0)).is_true()
	oscillator._sin_phase = 0.0
	assert_bool(is_equal_approx(oscillator.wave_between(0.0, 10.0), 5.0)).is_true()


func test_amount_ramps_toward_target_while_swaying() -> void:
	var oscillator: FeedbackOscillatorEffect = auto_free(FeedbackOscillatorEffect.new())
	oscillator.trigger = FeedbackOscillatorEffect.Trigger.WHILE_HOVERED
	oscillator.fade_sec = 0.25

	assert_bool(is_equal_approx(oscillator._target_amount, 0.0)).is_true()

	oscillator._apply_state(true, false)
	assert_bool(is_equal_approx(oscillator._target_amount, 1.0)).is_true()

	oscillator._tick(oscillator.fade_sec)
	assert_bool(is_equal_approx(oscillator._amount, 1.0)).is_true()
	assert_bool(oscillator.is_animating()).is_true()

	oscillator._apply_state(false, false)
	oscillator._tick(oscillator.fade_sec)
	assert_bool(is_equal_approx(oscillator._amount, 0.0)).is_true()
	assert_bool(oscillator.is_animating()).is_false()
