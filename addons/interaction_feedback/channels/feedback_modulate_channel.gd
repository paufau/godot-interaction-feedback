class_name FeedbackModulateChannel
extends FeedbackChannel

static var instance := FeedbackModulateChannel.new()


func get_identity() -> Variant:
	return Color.WHITE


func combine(accumulated: Variant, value: Variant) -> Variant:
	return accumulated * value


func is_neutral(value: Variant) -> bool:
	return value.is_equal_approx(Color.WHITE)


func equals(a: Variant, b: Variant) -> bool:
	return a.is_equal_approx(b)


func capture_base(target: CanvasItem) -> Variant:
	return target.modulate


func write(target: CanvasItem, base: Variant, value: Variant) -> Variant:
	var composed := combine(base, value)
	target.modulate = composed
	return composed
