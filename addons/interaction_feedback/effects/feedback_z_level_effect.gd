@tool
@icon("uid://cemkrmy4pvxwp")
class_name FeedbackZLevelEffect
extends FeedbackEffect

@export var hovered_z := 1
@export var pressed_z := 0

var _z := 0


func _get_channel() -> FeedbackChannel:
	return FeedbackZIndexChannel.instance


func _get_value() -> Variant:
	return _z


func _apply_state(hovered: bool, pressed: bool) -> void:
	var value := 0

	if hovered:
		value += hovered_z

	if pressed:
		value += pressed_z

	animate(&"_z", value, 0.0)


func uses_tween() -> bool:
	return false


func reset() -> void:
	super()
	_z = 0
