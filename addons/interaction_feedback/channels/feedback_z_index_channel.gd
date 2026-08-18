class_name FeedbackZIndexChannel
extends FeedbackChannel

static var instance := FeedbackZIndexChannel.new()


func get_identity() -> Variant:
	return 0


func combine(accumulated: Variant, value: Variant) -> Variant:
	return accumulated + value


func is_neutral(value: Variant) -> bool:
	return value == 0


func capture_base(target: CanvasItem) -> Variant:
	return target.z_index


func write(target: CanvasItem, base: Variant, value: Variant) -> void:
	var composed: int = combine(base, value)
	target.z_index = clampi(
		composed, RenderingServer.CANVAS_ITEM_Z_MIN, RenderingServer.CANVAS_ITEM_Z_MAX
	)
