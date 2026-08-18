class_name FeedbackScaleChannel
extends FeedbackChannel

static var instance := FeedbackScaleChannel.new()


func get_identity() -> Variant:
	return Vector2.ONE


func combine(accumulated: Variant, value: Variant) -> Variant:
	return accumulated * value


func is_neutral(value: Variant) -> bool:
	return value.is_equal_approx(Vector2.ONE)


func capture_base(target: CanvasItem) -> Variant:
	if target is Control:
		return get_identity()

	return (target as Node2D).scale


func write(target: CanvasItem, base: Variant, value: Variant) -> void:
	if target is Control:
		(target as Control).offset_transform_scale = combine(base, value)
	else:
		(target as Node2D).scale = combine(base, value)
