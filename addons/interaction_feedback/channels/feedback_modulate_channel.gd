class_name FeedbackModulateChannel
extends FeedbackChannel

static var instance := FeedbackModulateChannel.new()


func get_identity() -> Variant:
	return Color.WHITE


func combine(accumulated: Variant, value: Variant) -> Variant:
	return accumulated * value


func is_neutral(value: Variant) -> bool:
	return value.is_equal_approx(Color.WHITE)


func capture_base(target: CanvasItem) -> Variant:
	return target.modulate


func write(target: CanvasItem, base: Variant, value: Variant) -> void:
	target.modulate = combine(base, value)
