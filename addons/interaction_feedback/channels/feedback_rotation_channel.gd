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


func capture_base(target: CanvasItem) -> Variant:
	if target is Control:
		return get_identity()

	return (target as Node2D).rotation


func write(target: CanvasItem, base: Variant, value: Variant) -> void:
	if target is Control:
		var control := target as Control
		control.offset_transform_rotation = base + value * _get_squareness(control)
	else:
		(target as Node2D).rotation = combine(base, value)


func _get_squareness(control: Control) -> float:
	var size := control.size
	var longest := maxf(size.x, size.y)

	if longest <= 0.0:
		return 1.0

	return maxf(sqrt(minf(size.x, size.y) / longest), MIN_RATIO)
