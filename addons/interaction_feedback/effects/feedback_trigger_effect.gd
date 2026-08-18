@tool
@icon("uid://b6d2jri5qa3ft")
class_name FeedbackTriggerEffect
extends FeedbackEffect

@export var on_hover := true
@export var on_press := false

var _was_hovered := false
var _was_pressed := false


func fire() -> void:
	pass


func _apply_state(hovered: bool, pressed: bool) -> void:
	var entered_hover := hovered and not _was_hovered
	var entered_press := pressed and not _was_pressed

	_was_hovered = hovered
	_was_pressed = pressed

	if (entered_hover and on_hover) or (entered_press and on_press):
		fire()


func _replay_state(hovered: bool, pressed: bool) -> void:
	_was_hovered = hovered
	_was_pressed = pressed


func reset() -> void:
	super()
	_was_hovered = false
	_was_pressed = false
