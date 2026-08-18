@tool
@icon("uid://b6d2jri5qa3ft")
class_name FeedbackEffect
extends Node

signal animation_started

@export var enabled := true:
	set(value):
		if enabled == value:
			return

		enabled = value

		if not enabled:
			reset()
		else:
			var feedback := get_parent() as InteractionFeedback
			if feedback != null:
				feedback.replay_state(self)

		animation_started.emit()

@export var transition: Tween.TransitionType = Tween.TRANS_CUBIC
@export var easing: Tween.EaseType = Tween.EASE_OUT

var _tween: Tween
var _targets := {}


func _validate_property(property: Dictionary) -> void:
	if not uses_tween() and property.name in [&"transition", &"easing"]:
		property.usage = PROPERTY_USAGE_NONE


## The channel this effect writes, or null for one that touches no node prop
## The compositor only writes properties some effect has claimed
func _get_channel() -> FeedbackChannel:
	return null


## This effect's current contribution, folded in with the channel's operator
func _get_value() -> Variant:
	return null


## Called by the compositor whenever the pointer state changes
func _apply_state(_hovered: bool, _pressed: bool) -> void:
	pass


## Called when the compositor re-sends an already-current state
## Effects that fire on state entry override this to sync without firing
func _replay_state(hovered: bool, pressed: bool) -> void:
	_apply_state(hovered, pressed)


## Called by the compositor every composed frame
func _tick(_delta: float) -> void:
	pass


## True while this effect's value is still moving
func is_animating() -> bool:
	return _tween != null and _tween.is_valid() and _tween.is_running()


## Override to false in effects that change instantly or drive themselves
func uses_tween() -> bool:
	return true


## Drops any running animation and returns to the neutral value
func reset() -> void:
	_kill_tween()
	_targets.clear()


## Moves one of this effect's own properties towards "value"
func animate(property: StringName, value: Variant, duration_sec: float) -> void:
	if not _retarget(property, value):
		return

	if duration_sec > 0.0 and is_inside_tree():
		_kill_tween()
		_tween = create_tween().set_ease(easing).set_trans(transition)
		_tween.tween_property(self, NodePath(property), value, duration_sec)
		animation_started.emit()
	else:
		_snap(property, value)


# Skips values already on their way
func _retarget(property: StringName, value: Variant) -> bool:
	if _targets.has(property) and _targets[property] == value:
		return false

	_targets[property] = value

	return true


func _snap(property: StringName, value: Variant) -> void:
	_kill_tween()
	set(property, value)
	animation_started.emit()


# For subclasses needing more than the single property animate() handles
func _begin_tween() -> Tween:
	if not is_inside_tree():
		return null

	_kill_tween()

	_tween = create_tween().set_ease(easing).set_trans(transition)
	animation_started.emit()

	return _tween


func _kill_tween() -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()

	_tween = null
