extends Control

const CONTROLS_SCENE := preload("uid://ngtnd7h0d6h0")
const NODE2D_SCENE := preload("uid://bswv7sc1reh0r")

@onready var _stage: Control = $Margin/Layout/Scroll/Stage
@onready var _switch: CheckButton = $Margin/Layout/Header/Switch

var _current: Node


func _ready() -> void:
	_switch.toggled.connect(_show)
	_show(false)


func _show(node2d: bool) -> void:
	if _current != null:
		_current.queue_free()

	_current = (NODE2D_SCENE if node2d else CONTROLS_SCENE).instantiate()
	_stage.add_child(_current)

	if not node2d:
		_grab_first_focus.call_deferred()


func _grab_first_focus() -> void:
	if not is_instance_valid(_current):
		return

	var buttons := _current.find_children("*", "Button", true, false)

	if not buttons.is_empty():
		(buttons[0] as Button).grab_focus()
