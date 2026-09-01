@tool
@icon("uid://dvn1u0emkre5r")
class_name InteractionFeedback
extends Node

## Composes stackable effects

signal state_changed(hovered: bool, pressed: bool)

## What to do with the parent's own hover signals
enum TouchMode {
	## Hover on mouse, press-only on touch
	AUTO,
	## Always play hover, whatever the input device
	HOVER_ENABLED,
	## Never play hover
	PRESS_ONLY,
}

const INPUT_MODE_PATH := ^"/root/FeedbackInputMode"
const IDLE_FRAMES_BEFORE_SLEEP := 2

enum DisabledSuppression {
	NONE = 0, ## Play everything even when disabled
	HOVER = 1, ## Suppress hovers
	PRESS = 2, ## Suppress presses
	ALL = HOVER | PRESS, ## Suppress both
}

static var _warned_missing_input_mode := false

@export var enabled := true:
	set(value):
		if enabled == value:
			return

		enabled = value

		if enabled:
			_catch_up_hover()
			_broadcast_state_change()
		else:
			reset()

@export var auto_connect := true
@export var pivot_ratio := Vector2(0.5, 0.5):
	set(value):
		pivot_ratio = value
		_apply_pivot()

@export var touch_mode: TouchMode = TouchMode.AUTO
@export var hover_on_focus := true
@export var focus_hover_requires_navigation := true # drops hover when input device changes
@export var activate_action := &"ui_select"
@export var suppress_when_disabled: DisabledSuppression = DisabledSuppression.PRESS

@export_tool_button("Enable parent input_pickable")
var _enable_input_handling_button := _enable_parent_input_handling

var base_position: Vector2:
	get:
		var channel: FeedbackChannel = FeedbackOffsetChannel.instance

		if _bases.has(channel):
			return _bases[channel]

		return (_target as Node2D).position if _target is Node2D else Vector2.ZERO
	set(value):
		if _is_control:
			push_warning("base_position is ignored for Control targets; move the Control's own position/offset instead.")
			return

		if base_position.is_equal_approx(value):
			return

		_bases[FeedbackOffsetChannel.instance] = value
		_apply_base_position()

var _target: CanvasItem
var _is_control := false
var _hovered := false
var _pressed := false
var _is_mouse_over := false
var _is_focused := false
var _press_index := -1
var _composed := {}
var _idle_frames := 0
var _input_mode: Node
var _effects: Array[FeedbackEffect] = []
var _bases := {}
var _written := {}
var _external_modification_guard := ExternalModificationGuard.new()


## Creates a compositor and parents it to "target"
## Pass "auto_connect" here rather than assigning it after
static func attach(target: CanvasItem, auto_connect := true) -> InteractionFeedback:
	var feedback := InteractionFeedback.new()

	feedback.name = "InteractionFeedback"
	feedback.auto_connect = auto_connect
	target.add_child(feedback)

	return feedback


func _ready() -> void:
	_sleep()

	if Engine.is_editor_hint():
		return

	_target = get_parent() as CanvasItem

	if _target == null:
		push_error("InteractionFeedback must be a child of a CanvasItem.")
		return

	_input_mode = get_node_or_null(INPUT_MODE_PATH)

	if _input_mode == null and not _warned_missing_input_mode:
		_warned_missing_input_mode = true
		push_warning(
			(
				"FeedbackInputMode autoload not found (enable the InteractionFeedback "
				+"plugin); falling back to DisplayServer.is_touchscreen_available()."
			)
		)

	_is_control = _target is Control

	if _is_control:
		(_target as Control).offset_transform_enabled = true

	_apply_pivot()

	child_exiting_tree.connect(_handle_child_exiting)

	for child in get_children():
		var effect := child as FeedbackEffect

		if effect != null:
			_register_effect(effect)

	if _is_control and hover_on_focus and focus_hover_requires_navigation and _input_mode != null:
		_input_mode.device_changed.connect(_handle_device_changed)

	if auto_connect:
		_connect_target()

	# Compose whatever happened before this node had a target
	_wake()


func _process(delta: float) -> void:
	_external_modification_guard.check(_target)

	for effect in _effects:
		if effect.enabled:
			effect._tick(delta)

	if _compose():
		_idle_frames = 0
		return

	_idle_frames += 1

	if _idle_frames >= IDLE_FRAMES_BEFORE_SLEEP:
		_sleep()


func _exit_tree() -> void:
	if _input_mode != null and _input_mode.device_changed.is_connected(_handle_device_changed):
		_input_mode.device_changed.disconnect(_handle_device_changed)

	if Engine.is_editor_hint() or not is_instance_valid(_target):
		return

	_composed.clear()
	_write_channels()

	if _is_control:
		(_target as Control).offset_transform_enabled = false

	_written.clear()
	_bases.clear()
	_sleep()


func add_effect(effect: FeedbackEffect) -> void:
	add_child(effect)

	if Engine.is_editor_hint():
		return

	_register_effect(effect)

	if _hovered or _pressed:
		replay_state(effect)


func remove_effect(effect: FeedbackEffect) -> void:
	if effect != null and effect.get_parent() == self:
		remove_child(effect)


func get_effects() -> Array[FeedbackEffect]:
	return _effects.duplicate()


func get_target() -> CanvasItem:
	return _target


func get_input_mode() -> Node:
	return _input_mode


func replay_state(effect: FeedbackEffect) -> void:
	if Engine.is_editor_hint():
		return

	effect._replay_state(_hovered, _pressed)


func is_hovered() -> bool:
	return _hovered


func is_pressed() -> bool:
	return _pressed


func is_pointer_hovered() -> bool:
	return _is_mouse_over


func set_hovered(value: bool) -> void:
	if _hovered == value:
		return

	_hovered = value
	_broadcast_state_change()


func set_pressed(value: bool) -> void:
	if _pressed == value:
		return

	_pressed = value
	_broadcast_state_change()


## Stops everything and restores the node's initial state
func reset() -> void:
	_hovered = false
	_pressed = false
	_is_mouse_over = false
	_is_focused = false
	_press_index = -1

	_sleep()

	for effect in _effects:
		effect.reset()

	_compose()


func _register_effect(effect: FeedbackEffect) -> void:
	if not _effects.has(effect):
		_effects.append(effect)
		effect.animation_started.connect(_wake)

	if _target != null:
		_claim(effect._get_channel())

	# An effect moving since its own _ready emitted animation_started before connection existed
	if effect.is_animating():
		_wake()


func _handle_child_exiting(child: Node) -> void:
	if not (child is FeedbackEffect):
		return

	_effects.erase(child)
	_wake()


func _connect_target() -> void:
	if _target is BaseButton:
		var button := _target as BaseButton

		button.mouse_entered.connect(_handle_pointer_entered)
		button.mouse_exited.connect(_handle_pointer_exited)
		button.button_down.connect(set_pressed.bind(true))
		button.button_up.connect(set_pressed.bind(false))
		button.gui_input.connect(_handle_activate_input)

		_connect_focus(button)
		_catch_up_hover()

		return

	if _is_control:
		var control := _target as Control

		control.mouse_entered.connect(_handle_pointer_entered)
		control.mouse_exited.connect(_handle_pointer_exited)
		control.gui_input.connect(_handle_gui_input)

		_connect_focus(control)
		_catch_up_hover()

		return

	if _target is CollisionObject2D:
		var parent := _target as CollisionObject2D

		if not parent.input_pickable:
			push_warning(
				(
					"%s has input_pickable disabled; InteractionFeedback can't auto-connect "
					+"hover/press. Enable input_pickable on the target."
				)
				% parent.name
			)

		parent.mouse_entered.connect(_handle_pointer_entered)
		parent.mouse_exited.connect(_handle_collision_exited)
		parent.input_event.connect(_handle_collision_input)


func _connect_focus(control: Control) -> void:
	if not hover_on_focus:
		return

	control.focus_entered.connect(_handle_focus_entered)
	control.focus_exited.connect(_handle_focus_exited)


func _catch_up_hover() -> void:
	if not auto_connect:
		return

	var button := _target as BaseButton

	if button != null and button.is_hovered():
		_handle_pointer_entered()

	if hover_on_focus and _target is Control and (_target as Control).has_focus():
		_update_focus(true)


func _handle_pointer_entered() -> void:
	if _is_hover_suppressed() or _disabled_suppresses(DisabledSuppression.HOVER):
		return

	_is_mouse_over = true
	_update_hover()


func _handle_pointer_exited() -> void:
	_is_mouse_over = false
	_update_hover()


func _handle_focus_entered() -> void:
	_update_focus(true)


func _handle_focus_exited() -> void:
	_update_focus(false)
	set_pressed(false)


func _handle_device_changed(_device: FeedbackInputDevice.Device) -> void:
	if _is_control:
		_update_focus((_target as Control).has_focus())


func _update_focus(focused: bool) -> void:
	var active := focused and not _is_mouse_over and not _is_hover_suppressed() and not _disabled_suppresses(DisabledSuppression.HOVER)
	_is_focused = active and _is_focus_hover_allowed()
	_update_hover()


func _is_focus_hover_allowed() -> bool:
	if not focus_hover_requires_navigation or _input_mode == null:
		return true

	return _input_mode.is_navigation_active()


func _update_hover() -> void:
	set_hovered(_is_mouse_over or _is_focused)


func _disabled_suppresses(feedback: DisabledSuppression) -> bool:
	return (suppress_when_disabled & feedback) != 0 and _target is BaseButton and (_target as BaseButton).disabled


func _handle_collision_input(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	_handle_gui_input(event)


func _handle_collision_exited() -> void:
	_handle_pointer_exited()

	if _pressed:
		_press_index = -1
		set_pressed(false)


func _handle_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var button := event as InputEventMouseButton

		if button.button_index == MOUSE_BUTTON_LEFT:
			set_pressed(button.pressed)
	elif event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch

		# Only the finger that pressed may release, or a second tap would end the first finger's press early
		if touch.pressed:
			if not _pressed:
				_press_index = touch.index
				set_pressed(true)
		elif touch.index == _press_index:
			_press_index = -1
			set_pressed(false)
	else:
		_handle_activate_input(event)


func _handle_activate_input(event: InputEvent) -> void:
	if event.is_action_pressed(activate_action) and not _disabled_suppresses(DisabledSuppression.PRESS):
		set_pressed(true)
	elif event.is_action_released(activate_action):
		set_pressed(false)


func _broadcast_state_change() -> void:
	for effect in _effects:
		effect._apply_state(_hovered, _pressed)

	state_changed.emit(_hovered, _pressed)
	_wake()


func _wake() -> void:
	if not enabled or _target == null or Engine.is_editor_hint():
		return

	# Asleep and neutral means the node sits on its base
	if not is_processing() and _is_composed_neutral():
		_capture_bases()

	_idle_frames = 0
	set_process(true)


func _sleep() -> void:
	set_process(false)
	_external_modification_guard.reset()


func _compose() -> bool:
	if _target == null:
		return false

	_composed.clear()

	var animating := false

	for effect in _effects:
		if not effect.enabled:
			continue

		animating = animating or effect.is_animating()

		var channel := effect._get_channel()

		if channel == null:
			continue

		_claim(channel)
		_accumulate(channel, effect._get_value())

	_write_channels()

	return animating


func _write_channels() -> void:
	for channel: FeedbackChannel in _written:
		_external_modification_guard.record(channel, channel.write(_target, _bases[channel], _get_composed_value(channel)))


func _accumulate(channel: FeedbackChannel, value: Variant) -> void:
	_composed[channel] = channel.combine(_get_composed_value(channel), value)


func _get_composed_value(channel: FeedbackChannel) -> Variant:
	return _composed.get(channel, channel.get_identity())


func _is_composed_neutral() -> bool:
	for channel: FeedbackChannel in _composed:
		if not channel.is_neutral(_composed[channel]):
			return false

	return true


# Claimed at registration, before anything animates, so a spawn-time
# reveal tween is never mistaken for the base value
func _claim(channel: FeedbackChannel) -> void:
	if channel == null or _written.has(channel):
		return

	_written[channel] = true

	if not _bases.has(channel):
		_bases[channel] = channel.capture_base(_target)


func _capture_bases() -> void:
	for channel: FeedbackChannel in _written:
		_bases[channel] = channel.capture_base(_target)

	_external_modification_guard.reset()


# Lands a layout move while the compositor is asleep and composing nothing
func _apply_base_position() -> void:
	if _target == null or _is_control:
		return

	var channel := FeedbackOffsetChannel.instance
	channel.write(_target, base_position, _get_composed_value(channel))
	_external_modification_guard.reset()


func _apply_pivot() -> void:
	if _is_control:
		(_target as Control).offset_transform_pivot_ratio = pivot_ratio


func _is_hover_suppressed() -> bool:
	match touch_mode:
		TouchMode.HOVER_ENABLED:
			return false
		TouchMode.PRESS_ONLY:
			return true

	if _input_mode == null:
		return DisplayServer.is_touchscreen_available()

	return _input_mode.is_touch_active()


func _parent_can_handle_input() -> bool:
	var parent := get_parent() as CollisionObject2D

	return parent == null or parent.input_pickable


func _needs_input_fix() -> bool:
	return auto_connect and not _parent_can_handle_input()


func _get_configuration_warnings() -> PackedStringArray:
	if not _needs_input_fix():
		return PackedStringArray()

	return [
		"The parent CollisionObject2D has input_pickable disabled, so its "
		+"mouse/input signals never fire. Use the \"Enable parent input_pickable\" "
		+"button, or turn input_pickable on yourself."
	]


func _validate_property(property: Dictionary) -> void:
	if property.name == "_enable_input_handling_button" and not _needs_input_fix():
		property.usage = PROPERTY_USAGE_NONE


func _enable_parent_input_handling() -> void:
	if not Engine.is_editor_hint():
		return

	var parent := get_parent() as CollisionObject2D

	if parent == null:
		return

	var undo_redo = Engine.get_singleton(&"EditorInterface").get_editor_undo_redo()

	undo_redo.create_action("Enable input_pickable")
	undo_redo.add_do_property(parent, "input_pickable", true)
	undo_redo.add_undo_property(parent, "input_pickable", parent.input_pickable)
	undo_redo.commit_action()

	update_configuration_warnings()
	notify_property_list_changed()
