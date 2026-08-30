class_name FeedbackOffsetChannel
extends FeedbackChannel


static var instance := FeedbackOffsetChannel.new()


func get_identity() -> Variant:
	return Vector2.ZERO


func combine(accumulated: Variant, value: Variant) -> Variant:
	return accumulated + value


func is_neutral(value: Variant) -> bool:
	return value.is_zero_approx()


func equals(a: Variant, b: Variant) -> bool:
	return a.is_equal_approx(b)


func capture_base(target: CanvasItem) -> Variant:
	if target is Control:
		return get_identity()

	return (target as Node2D).position


func write(target: CanvasItem, base: Variant, value: Variant) -> Variant:
	var composed := combine(base, value)

	if target is Control:
		(target as Control).offset_transform_position = composed
		return null

	(target as Node2D).position = composed
	return composed
