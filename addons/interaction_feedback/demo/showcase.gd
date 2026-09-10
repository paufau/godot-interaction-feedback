extends Control

const Cursor := preload("res://addons/interaction_feedback/demo/showcase_cursor.gd")
const STAGGER_SEC := 2.0

@onready var _cursors: CanvasLayer = $Cursors
@onready var _demo: Control = $Center/DemoControls


func _ready() -> void:
	var index := 0

	for node in _demo.find_children("*", "", true, false):
		var feedback := node as InteractionFeedback

		if feedback == null:
			continue

		var effects := feedback.get_effects()

		if effects.all(func(effect: FeedbackEffect) -> bool: return effect is FeedbackHapticEffect):
			continue # nothing to see

		(feedback.get_parent() as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE

		var cursor := Cursor.new()
		cursor.feedback = feedback
		cursor.sway = effects.any(func(effect: FeedbackEffect) -> bool: return effect is FeedbackStickyEffect)
		cursor.start_delay_sec = fposmod(index * 0.618034, 1.0) * STAGGER_SEC # golden-ratio spread, deterministic
		_cursors.add_child(cursor)
		index += 1
