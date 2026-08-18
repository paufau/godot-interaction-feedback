class_name FeedbackChannel
extends RefCounted

func get_identity() -> Variant:
	return null


func combine(_accumulated: Variant, value: Variant) -> Variant:
	return value


func is_neutral(_value: Variant) -> bool:
	return false


func capture_base(_target: CanvasItem) -> Variant:
	return get_identity()


func write(_target: CanvasItem, _base: Variant, _value: Variant) -> void:
	pass
