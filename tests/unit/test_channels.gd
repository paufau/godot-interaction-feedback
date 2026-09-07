extends GdUnitTestSuite


func test_scale_channel_is_multiplicative() -> void:
	var channel := FeedbackScaleChannel.instance
	assert_bool((channel.get_identity() as Vector2).is_equal_approx(Vector2.ONE)).is_true()
	assert_bool(channel.combine(Vector2(2, 2), Vector2(1.5, 0.5)).is_equal_approx(Vector2(3, 1))).is_true()
	assert_bool(channel.is_neutral(Vector2.ONE)).is_true()
	assert_bool(channel.is_neutral(Vector2(1.06, 1.06))).is_false()


func test_offset_channel_is_additive() -> void:
	var channel := FeedbackOffsetChannel.instance
	assert_bool(channel.combine(Vector2(3, -2), Vector2(1, 5)).is_equal_approx(Vector2(4, 3))).is_true()
	assert_bool(channel.is_neutral(Vector2.ZERO)).is_true()
	assert_bool(channel.is_neutral(Vector2(0, -10))).is_false()


func test_modulate_channel_is_multiplicative() -> void:
	var channel := FeedbackModulateChannel.instance
	assert_bool(channel.combine(Color(0.5, 0.5, 0.5), Color(2, 2, 2)).is_equal_approx(Color(1, 1, 1))).is_true()
	assert_bool(channel.is_neutral(Color.WHITE)).is_true()
	assert_bool(channel.is_neutral(Color(1.1, 1.1, 1.1))).is_false()


func test_rotation_channel_is_additive() -> void:
	var channel := FeedbackRotationChannel.instance
	assert_bool(is_equal_approx(channel.combine(0.5, 0.25), 0.75)).is_true()
	assert_bool(channel.is_neutral(0.0)).is_true()


func test_rotation_squareness_damps_wide_controls() -> void:
	var channel := FeedbackRotationChannel.instance

	var square: Control = auto_free(Control.new())
	square.size = Vector2(100, 100)
	assert_bool(is_equal_approx(channel._get_squareness(square), 1.0)).is_true()

	var wide: Control = auto_free(Control.new())
	wide.size = Vector2(200, 20)
	assert_bool(is_equal_approx(channel._get_squareness(wide), FeedbackRotationChannel.MIN_RATIO)).is_true()

	var zero: Control = auto_free(Control.new())
	zero.size = Vector2.ZERO
	assert_bool(is_equal_approx(channel._get_squareness(zero), 1.0)).is_true()


func test_z_index_channel_adds_and_clamps() -> void:
	var channel := FeedbackZIndexChannel.instance
	assert_int(int(channel.combine(3, 4))).is_equal(7)

	var target: Node2D = auto_free(Node2D.new())
	var written: int = channel.write(target, RenderingServer.CANVAS_ITEM_Z_MAX, 10)
	assert_int(written).is_equal(RenderingServer.CANVAS_ITEM_Z_MAX)
	assert_int(target.z_index).is_equal(RenderingServer.CANVAS_ITEM_Z_MAX)
