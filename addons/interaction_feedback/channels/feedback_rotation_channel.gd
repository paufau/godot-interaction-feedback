class_name FeedbackRotationChannel
extends FeedbackChannel

const MIN_RATIO := 0.35

static var instance := FeedbackRotationChannel.new()


func get_identity() -> Variant:
	return 0.0


func combine(accumulated: Variant, value: Variant) -> Variant:
	return accumulated + value


func is_neutral(value: Variant) -> bool:
	return is_zero_approx(value)


func equals(a: Variant, b: Variant) -> bool:
	return is_equal_approx(a, b)


func capture_base(target: CanvasItem) -> Variant:
	if target is Control:
		return get_identity()

	return (target as Node2D).rotation


func write(target: CanvasItem, base: Variant, value: Variant) -> Variant:
	if target is Control:
		var control := target as Control
		control.offset_transform_rotation = base + value * _get_squareness(control)
		return null

	var composed := combine(base, value)
	(target as Node2D).rotation = composed
	return composed


func _get_squareness(control: Control) -> float:
	var size := control.size
	var longest := maxf(size.x, size.y)

	if longest <= 0.0:
		return 1.0

	return maxf(sqrt(minf(size.x, size.y) / longest), MIN_RATIO)
